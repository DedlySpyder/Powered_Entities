require("actions")
require("config")
require("tasks")
require("util")

--[[
Builds a report file in script-output of all of the entities that will be powered by this mod
This should cover any mod situation that the base mod will cover, with the exeption of if another mod cares about force or surface for doing something to make an entity require electricity
]]--


Report = {}

Report.FILE_NAME = "Powered_Entities_report.txt"
Report.SURFACE_SIZE = 10


function Report.cleanup()
	global.reportEntities = nil
	global.reportInProgress = nil
	
	Actions.Automatic.techCheck = global.reportTechCheckBackup
	global.reportTechCheckBackup = nil
	
	game.delete_surface("Powered_Entities_report")
	game.merge_forces("Powered_Entities_report", "neutral")
end

function Report.buildReport()
	if not global.reportInProgress then
		Util.printAll({"Powered-Entities-report-generation-start"})
		
		local surface = game.create_surface("Powered_Entities_report", {width=Report.SURFACE_SIZE, height=Report.SURFACE_SIZE})
		surface.request_to_generate_chunks({0,0}, 1)
		surface.force_generate_chunk_requests()
		
		local force = game.create_force("Powered_Entities_report")
		global.reportTechCheckBackup = Actions.Automatic.techCheck
		Actions.Automatic.techCheck = Report.fakeTechCheck
		
		global.reportEntities = {}
		global.reportInProgress = true
		
		Report.scheduleTasks(surface, force, Report.getEntities())
	else
		Util.debugLog("Skipping report, one is already running")
	end
end

function Report.fakeTechCheck(force)
	return force["name"] == "Powered_Entities_report" or global.reportTechCheckBackup(force)
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

function Report.scheduleTasks(surface, force, entities)
	Util.traceLog("Scheduling tasks for " .. table_size(entities) .. " entities")
	
	-- Clean up any remnants
	for _, trash in pairs(surface.find_entities()) do
		trash.destroy()
	end
	
	local leftovers = {}
	local placed = 0
	for _, entityPrototype in pairs(entities) do
		local entityName = entityPrototype["name"]
		local position = surface.find_non_colliding_position(entityName, {0,0}, Report.SURFACE_SIZE, 0.5, true)
		if position then
			Util.traceLog("Found position for " .. entityName)
			local otherEntities = surface.count_entities_filtered{area=Util.positionToBoundingBox(position, entityPrototype["selection_box"])}
			if otherEntities == 0 then
				local entity = surface.create_entity{name=entityName, position=position, force=force, raise_built=true}
				
				if entity and entity.valid then
					global.reportEntities[entityName] = {prototype=entityPrototype, built=true, destroyed=false, checks={powered=false, poweredSize=nil, destroyedPoles=false, irregularity=false}}
					
					local args = {entity, entityName, surface, entity.selection_box}
					Tasks.scheduleTask(Tasks.uniqueNameForEntity(entity) .. "-report-build-check", Report.Tasks.buildCheck, args, Actions.BASE_DELAY + 2)
					Tasks.scheduleTask(Tasks.uniqueNameForEntity(entity) .. "-report-destroy", Report.Tasks.destroy, args, Actions.BASE_DELAY + 3)
					Tasks.scheduleTask(Tasks.uniqueNameForEntity(entity) .. "-report-destroy-check", Report.Tasks.destroyCheck, args, Actions.BASE_DELAY + 6)
					placed = placed + 1
				else
					Util.traceLog("Failed to place " .. entityName)
					table.insert(leftovers, entityPrototype)
				end
			else
				Util.traceLog("Found other entities when trying to place " .. entityName)
				table.insert(leftovers, entityPrototype)
			end
		else
			Util.traceLog("Could not find position for " .. entityName)
			table.insert(leftovers, entityPrototype)
		end
	end
	
	if placed > 0 then
		Util.traceLog("Scheduling new task for " .. #leftovers .. " leftovers")
		Tasks.scheduleTask(game.tick .. "-report-schedule-tasks", Report.scheduleTasks, {surface, force, leftovers}, Actions.BASE_DELAY + 9)
	else
		Util.traceLog("Did not place any entities, remaining " .. #leftovers .. " are unbuilt")
		for _, leftover in ipairs(leftovers) do
			global.reportEntities[leftover["prototype"]["name"]] = {prototype=leftover}
		end
		
		Report.generateReport()
		Report.cleanup()
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
		local bSize = b["size"]
		if tonumber(aSize) and tonumber(bSize) then
			return aSize < bSize
		elseif tonumber(aSize) then
			return true
		elseif tonumber(bSize) then
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
	
	local entities = surface.find_entities_filtered{area=area, type="electric-pole"}
	local powerPoles = Actions.findPowerPoles(entities)
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
	local count = #Actions.findPowerPoles(entities)
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
