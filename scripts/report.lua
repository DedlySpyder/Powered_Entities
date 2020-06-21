require("actions")
require("config")
require("entity_lib")
require("tasks")
require("util")

--[[
Builds a report file in script-output of all of the entities that will be powered by this mod
This should cover any mod situation that the base mod will cover, with the exeption of if another mod cares about force or surface for doing something to make an entity require electricity
]]--


Report = {}

Report.FILE_NAME = "Powered_Entities_report.txt"
Report.SURFACE_NAME = "Powered_Entities_report"
Report.FORCE_NAME = "Powered_Entities_report"

Report.ENTITIES_PER_ROW = 10
Report.MAX_ROWS = 10

Report.BUILD_CHECK_DELAY = 2
Report.DESTROY_DELAY = 3
Report.DESTROY_CHECK_DELAY = 6
Report.REPORT_GENERATION_DELAY = 9

function Report.cleanup()
	global.reportEntities = nil
	global.reportInProgress = nil
	
	-- These can be nil if a cleanup is called after a save/load
	-- But, in that case these will already be correct
	if global.reportTechCheckBackup then
		Actions.techCheck = global.reportTechCheckBackup
		global.reportTechCheckBackup = nil
	end

	if global.reportPowerPadFilter then
		Actions.Filters.containsPowerPad = global.reportPowerPadFilter
		global.reportPowerPadFilter = nil
	end
	
	game.delete_surface(Report.SURFACE_NAME)
	game.merge_forces(Report.FORCE_NAME, "neutral")
end

function Report.buildReport()
	if not global.reportInProgress then
		Util.printAll({"Powered-Entities-report-generation-start"})
		
		local entities = Report.getEntities()
		local largestSize, entityCount = Report.getLargestEntitySizeAndCount(entities)
		local surface = Report.buildSurface(largestSize, entityCount)
		
		local force = game.create_force(Report.FORCE_NAME)
		global.reportTechCheckBackup = Actions.techCheck
		Actions.techCheck = Report.fakeTechCheck
		
		global.reportPowerPadFilter = Actions.Filters.containsPowerPad
		Actions.Filters.containsPowerPad = Report.fakePowerPadFilter
		
		global.reportEntities = {}
		global.reportInProgress = true
		
		Report.buildEntitiesAndScheduleTasks(largestSize, surface, force, entities)
	else
		Util.debugLog("Skipping report, one is already running")
	end
end

function Report.fakeTechCheck(force)
	return force["name"] == Report.FORCE_NAME or global.reportTechCheckBackup(force)
end

function Report.fakePowerPadFilter(entities)
	for _, entity in pairs(entities) do
		if entity["force"]["name"] == Report.FORCE_NAME then return true end
	end
	return global.reportPowerPadFilter(entities)
end

function Report.getEntities()
	local fitlerFunc = function(prototype)
		for _, blackListType in ipairs(Config.BLACKLISTED_ENTITY_TYPES) do
			if prototype["type"] == blackListType then return false end
		end
		return true
	end
	
	return Util.filterTable(game.entity_prototypes, fitlerFunc)
end

function Report.getLargestEntitySizeAndCount(entities)
	local count = 0
	local largestSize = 0
	for _, entity in pairs(entities) do
		local size = Entity_Lib.getEntitySize(entity)
		if largestSize < size then
			largestSize = size
		end
		
		count = count + 1
	end
	
	return largestSize, count
end

function Report.buildSurface(largestSize, count)
	local singleEntitySize = largestSize * 2
	-- Number of columns is static
	local surfaceX = ((Report.ENTITIES_PER_ROW * singleEntitySize) + Report.ENTITIES_PER_ROW) * 4
	-- Number of rows could be less than the max
	local surfaceY = ((math.min(Report.MAX_ROWS, math.ceil(count / Report.ENTITIES_PER_ROW)) * singleEntitySize) + Report.MAX_ROWS) * 4
	
	Util.traceLog("Building " .. surfaceX .. "x" .. surfaceY .. " surface for reporting " .. count .. " entities of size " .. largestSize)
	local surface = game.create_surface(Report.SURFACE_NAME, {width = surfaceX, height = surfaceY, water = 0, default_enable_all_autoplace_controls = false})
	surface.request_to_generate_chunks({0,0}, math.max(surfaceX, surfaceY)/32 * 4) -- Only using positve numbers, so need x4 size
	surface.force_generate_chunk_requests()
	
	-- Clear junk, mainly cliffs
	for _, entity in pairs(surface.find_entities()) do
		entity.destroy()
	end
	
	return surface
end

function Report.buildEntitiesAndScheduleTasks(largestSize, surface, force, entities)
	Util.traceLog("Creating entities and scheduling tasks")
	
	local entityBoxSize = largestSize * 2
	local halfway = math.floor(entityBoxSize / 2)
	local count = 0
	local leftovers = {}
	for _, entityPrototype in pairs(entities) do
		local row = math.floor(count / Report.ENTITIES_PER_ROW)
		local column = count % Report.ENTITIES_PER_ROW
		local entityName = entityPrototype["name"]
		
		if row <= Report.MAX_ROWS then
			local position = {(column * entityBoxSize) + halfway, (row * entityBoxSize) + halfway}
			Util.traceLog("Placing " .. entityName .. " at row " .. row .. " column " .. column .. " - " .. serpent.line(position))
			
			local entity = surface.create_entity{name = entityName, position = position, force = force, raise_built = true}
			if entity and entity.valid then
				Util.traceLog("Building " .. entityName)
				global.reportEntities[entityName] = {prototype=entityPrototype, built=true, destroyed=false, checks={powered=false, poweredSize=nil, destroyedPoles=false, irregularity=false}}
				
				local args = {entity, entityName, surface, entity.selection_box}
				Tasks.scheduleEphemeralTask(Tasks.uniqueNameForEntity(entity) .. "-report-build-check", Report.Tasks.buildCheck, args, Actions.BASE_DELAY + Report.BUILD_CHECK_DELAY)
				Tasks.scheduleEphemeralTask(Tasks.uniqueNameForEntity(entity) .. "-report-destroy", Report.Tasks.destroy, args, Actions.BASE_DELAY + Report.DESTROY_DELAY)
				Tasks.scheduleEphemeralTask(Tasks.uniqueNameForEntity(entity) .. "-report-destroy-check", Report.Tasks.destroyCheck, args, Actions.BASE_DELAY + Report.DESTROY_CHECK_DELAY)
				count = count + 1
			else
				Util.traceLog("Failed to place " .. entityName .. " trying it in a later iteration")
				table.insert(leftovers, entityPrototype)
			end
		else
			Util.traceLog("Max rows hit, delaying " .. entityName .. " to a later iteration")
			table.insert(leftovers, entityPrototype)
		end
	end
	
	if #leftovers > 0 and count > 0 then
		Util.traceLog("Scheduling next iteration for " .. #leftovers .. " leftover entities")
		Tasks.scheduleEphemeralTask(game.tick .. "-report-schedule-tasks", Report.buildEntitiesAndScheduleTasks, {largestSize, surface, force, leftovers}, Actions.BASE_DELAY + Report.REPORT_GENERATION_DELAY)
	else
		Util.traceLog("Either placed all entities or failed to place some altogether")
		for _, leftover in ipairs(leftovers) do
			local entityName = leftover["name"]
			Util.traceLog("Found unbuilt leftover: " .. entityName)
			global.reportEntities[entityName] = {prototype=leftover, built=false, destroyed=false}
		end
		
		Tasks.scheduleEphemeralTask(game.tick .. "-report-generation", Report.generateReport, {}, Actions.BASE_DELAY + Report.REPORT_GENERATION_DELAY)
		Tasks.scheduleTask(game.tick .. "-report-cleanup", "reportCleanup", {}, Actions.BASE_DELAY + Report.REPORT_GENERATION_DELAY + 1)
	end
end

function Report.generateReport()
	local reportEntities = global.reportEntities
	Util.traceLog("Building report for " .. table_size(reportEntities) .. " entities")
	game.write_file(Report.FILE_NAME, "Powered Entities Report\n")
	
	local sortFunc = function(a, b) return a["prototype"]["name"] < b["prototype"]["name"] end
	local reportData = Report.sortReportData(reportEntities)
	for _, entitiesData in pairs(reportData) do
		local size = entitiesData["size"]
		local entities = entitiesData["data"]
		
		if tonumber(size) then
			Report.writeSection("Powered Entities for power pole size " .. size, entities)
		elseif size == "unpowered" then
			Report.writeSection("Unpowered Entities", entities)
		elseif size == "unbuilt" then
			Report.writeSection("Unbuilt Entities", entities)
		end
	end
	
	Util.printAll({"Powered-Entities-report-generation-end", Report.FILE_NAME})
end

function Report.sortReportData(reportEntities)
	local groupedData = {}
	for _, data in pairs(reportEntities) do
		if data and data["checks"] and data["checks"]["powered"] then
			local size = data["checks"]["poweredSize"]
			if not groupedData[size] then groupedData[size] = {size=size, data={}} end
			table.insert(groupedData[size]["data"], data)
			
		elseif data["built"] then
			if not groupedData["unpowered"] then groupedData["unpowered"] = {size="unpowered", data={}} end
			table.insert(groupedData["unpowered"]["data"], data)
			
		else
			if not groupedData["unbuilt"] then groupedData["unbuilt"] = {size="unbuilt", data={}} end
			table.insert(groupedData["unbuilt"]["data"], data)
		end
	end
	
	-- Turn the grouped map into an array
	local dataList = {}
	for _, data in pairs(groupedData) do
		table.insert(dataList, data)
	end
	
	-- Sort the array by size
	local sortFunc = function(a,b)
		local aSize = a["size"]
		local aNum = tonumber(aSize)
		local bSize = b["size"]
		local bNum = tonumber(bSize)
		if aNum and bNum then
			return aNum < bNum
		elseif aNum then
			return true
		elseif bNum then
			return false
		elseif aSize == "unpowered" then
			return true
		else
			return false
		end
	end
	table.sort(dataList, sortFunc)
	
	return dataList
end

function Report.writeSection(header, entities)
	Util.traceLog("Writing section <" .. header .. "> of report for " .. tostring(#entities) .. " entities")
	local sortFunc = function(a, b) return a["prototype"]["name"] < b["prototype"]["name"] end
	Report.appendReport("\n" .. header)
	
	table.sort(entities, sortFunc)
	for _, entity in ipairs(entities) do
		Report.appendReport(Report.getLineFormatted(entity))
	end
end

function Report.getLineFormatted(entityData)
	local ternary = function(c, t, f) if c then return t else return f end end
	local built = ternary(entityData["built"], "", " <not built>")
	local destroyed = ternary(entityData["built"] and not entityData["destroyed"], " <not destroyed>", "")
	local checkDestoryedPoles = ternary(entityData["built"] and entityData["checks"] and not entityData["checks"]["destroyedPoles"], " <poles not destroyed>", "")
	local checkIrregularity = ternary(entityData["checks"] and entityData["checks"]["irregularity"], " <irregularity>", "")
	
	local prototype = entityData["prototype"]
	local selectionBox = prototype["selection_box"]
	local x = math.abs(selectionBox["left_top"].x) + math.abs(selectionBox["right_bottom"].x)
	local y = math.abs(selectionBox["left_top"].y) + math.abs(selectionBox["right_bottom"].y)
	local size = x .. "x" .. y
	
	return "  " .. prototype["name"] .. " - " .. size .. built .. destroyed .. checkDestoryedPoles .. checkIrregularity
end

function Report.appendReport(message)
	game.write_file(Report.FILE_NAME, message .. "\n", true)
end

Report.Tasks = {}

function Report.Tasks.buildCheck(entity, entityName, surface, area)
	if not (entity or entity.valid) then
		Report.Tasks.reportIrregularity("Original " .. entityName .. " destroyed when being built, still checking for power poles", entityName)
	end
	
	local entities = surface.find_entities_filtered{area=area}
	for _, foundEntity in pairs(entities) do
		local foundEntityName = foundEntity["name"]
		if foundEntityName ~= entityName and not string.find(foundEntityName, Config.INVISIBLE_POLE_BASE_NAME_ESCAPED) then
			Report.Tasks.reportIrregularity("Found other entity " .. foundEntityName, entityName)
		end
	end
	
	local powerPoles = Actions.Filters.findPowerPoles(entities)
	local count = #powerPoles
	if count > 0 then
		Util.traceLog("Found power poles for " .. entityName)
		global.reportEntities[entityName]["checks"]["powered"] = true
		global.reportEntities[entityName]["checks"]["poweredSize"] = Entity_Lib.getEntitySizeFromPowerPoleName(powerPoles[1]["name"])
		
		if count > 1 then
			Report.Tasks.reportIrregularity("Found " .. tostring(count) .. " power poles for " .. entityName, entityName)
		end
	end
end

function Report.Tasks.destroy(entity, entityName, surface, area)
	if entity and entity.valid then
		Util.traceLog("Destroying " .. entityName)
		entity.destroy({raise_destroy=true})
		global.reportEntities[entityName]["destroyed"] = true
	end
end

function Report.Tasks.destroyCheck(entity, entityName, surface, area)
	if entity and entity.valid then
		Report.Tasks.reportIrregularity("Found " .. entityName .. " when it should have been destroyed", entityName)
	end
	
	local entities = surface.find_entities_filtered{area=area, type="electric-pole"}
	local count = #Actions.Filters.findPowerPoles(entities)
	if count == 0 then
		Util.traceLog("Found no power poles for " .. entityName)
		global.reportEntities[entityName]["checks"]["destroyedPoles"] = true
	else
		Report.Tasks.reportIrregularity("Old power poles leftover after detruction", entityName)
	end
end

function Report.Tasks.reportIrregularity(message, entityName)
	Util.traceLog("Irregularity: " .. message)
	global.reportEntities[entityName]["checks"]["irregularity"] = true
end
