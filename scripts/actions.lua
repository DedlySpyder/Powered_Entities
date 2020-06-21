require("config")
require("entity_lib")
require("tasks")

--[[
So, in an attempt to just dynamically handle all entities that use power there are a few edge cases I need to account for

The vanilla examples are all straightforward, when an entity is created, I add an invisible power pole under it sized to the selection box
This will also work for most simple entities from other mods

The odd situations are when interacting with other mods, mainly I need to account for 2 scenarios (I believe):
- hidden electric energy interface(s) - I believe that other mods might have a nil selection box entity to accept power for an entity on top of it
	- In this scenario I will have to search the selection_box of the main entity for anything consuming power and place a power pole sized for the main entity (aka, the largest entity in that area)
- delayed placement - With the above scenario or in a different situation, another mod could modify the entities in an area after an entity is placed
	- In order to not have to account for these other mods, I will just delay any calculation on my end by 1 tick, so they have a chance to do their thing
]]--

Actions = {}

Actions.BASE_DELAY = 1

function Actions.init()
	global.isRegenerating = global.isRegenerating or false
end



-- General actions
function Actions.regeneratePowerPoles(forForce)
	if not global.isRegenerating then
		if forForce then Util.debugLog("Regenerating for force: " .. forForce.name) end
		
		local maxBatchSize = Config.RECALCULATE_BATCH_SIZE
		local iteration, batch = 0, 0
		for _, surface in pairs(game.surfaces) do
			for chunk in surface.get_chunks() do
				Tasks.scheduleTask(Tasks.uniqueNameForChunk(surface, chunk), "regeneratePowerPoles", {surface, chunk, forForce}, iteration)
				batch = batch + 1
				if batch == maxBatchSize then
					iteration = iteration + 1
					batch = 0
				end
			end
		end
		
		Tasks.scheduleTask("regeneration-complete", "regenerationComplete", {}, iteration + 5)
		
		Util.debugLog("Scheduled " .. (iteration * maxBatchSize) + batch .. " tasks for chunk-based powered entity regeneration")
		Util.printAll({"Powered-Entities-recalculate-warning", iteration, math.floor(iteration/60), math.ceil(iteration/30)})
		global.isRegenerating = true
	else
		Util.printAll({"Powered-Entities-recalculate-already-running"})
	end
end

function Actions.regenerationComplete(unused)
	Util.printAll({"Powered-Entities-recalculate-completed"})
	global.isRegenerating = false
end

function Actions.regeneratePowerPolesTask(surface, chunk, forForce)
	-- Make sure to clean up any orphaned power poles
	Actions.destroyInvisiblePowerPolesInArea(surface, forForce, chunk.area)
	
	local entities
	if forForce and forForce.valid then
		entities = surface.find_entities_filtered{area=chunk.area, force=forForce}
	else
		entities = surface.find_entities_filtered{area=chunk.area, type=Config.BLACKLISTED_ENTITY_TYPES, invert=true}
	end
	
	for _, entity in pairs(entities) do
		Actions.scheduleOnBuild(entity)
	end
end

function Actions.destroyInvisiblePowerPolesInArea(surface, force, area)
	if force and not force.valid then
		force = nil
	end
	
	local entities = surface.find_entities_filtered{area=area, force=force, type="electric-pole"}
	
	for _, powerPole in ipairs(entities) do
		if powerPole and powerPole.valid and string.find(powerPole.name, Config.INVISIBLE_POLE_BASE_NAME_ESCAPED) then
			Util.traceLog("Destroying found power pole " .. powerPole.name .. " at (" .. powerPole.position.x .. "," .. powerPole.position.y .. ")")
			powerPole.destroy()
		end
	end
end



-- Scheduling functions
function Actions.scheduleOnBuild(entity)
	if Actions.canSchedule("onBuild", entity) then
		Tasks.scheduleTask(Tasks.uniqueNameForEntity(entity), "onBuild", {entity, entity.name, entity.surface, entity.force, entity.selection_box}, Actions.BASE_DELAY)
	end
end

function Actions.scheduleOnDestroy(entity)
	if Actions.canSchedule("onDestroy", entity) then
		Tasks.scheduleTask(Tasks.uniqueNameForEntity(entity), "onDestroy", {entity, entity.name, entity.surface, entity.force, entity.selection_box}, Actions.BASE_DELAY)
	end
end

function Actions.canSchedule(funcName, entity)
	if entity and entity.valid and entity.name then
		Util.traceLog(funcName .. " called with entity " .. entity.name)
		return true
	else
		Util.traceLog(funcName .. " called with invalid entity or variable")
	end
end



-- Main actions
function Actions.onBuild(entity, entityName, surface, force, area)
	if not (entity and entity.valid) then
		Util.traceLog("WARN: On build triggering entity is no longer valid")
	end
	
	if Actions.techCheck(force) then
		local entityToPower = Actions.checkAreaForEntityToPower(surface, force, area)
		if entityToPower and entityToPower.valid then
			Util.traceLog("Found entity to power: " .. entityToPower["name"])
			local invisiblePoleName = Entity_Lib.getPowerPoleName(entityToPower.prototype)
			
			if invisiblePoleName then
				Util.traceLog("Powering " .. entityToPower["name"])
				local pole = surface.create_entity{name=invisiblePoleName, position=entityToPower.position, force=entityToPower.force}
				pole.destructible = false
			else
				Util.traceLog("Failed to get invisible power pole for " .. entityToPower.name)
			end
		end
	else
		Util.traceLog("Powered entities research not currently researched for force " .. force.name)
	end
end

function Actions.onDestroy(entity, entityName, surface, force, area)
	if not (entity and entity.valid) then
		Util.traceLog("WARN: On destroy triggering entity is no longer valid")
	end
	
	if Actions.techCheck(force) then
		Util.traceLog("Destroying all poles in area and checking for new powered entity(ies)")
		Actions.destroyInvisiblePowerPolesInArea(surface, force, area)
		
		local entities = surface.find_entities_filtered{area=area, force=force}
		for _, entity in pairs(entities) do
			Actions.onBuild(entity, entity["name"], surface, force, entity["selection_box"])
		end
	else
		Util.traceLog("Powered entities research not currently researched for force " .. force.name)
	end
end

function Actions.techCheck(force)
	return force.technologies[Config.TECHNOLOGY_NAME].researched
end



-- Internal functions
-- Check the area and return the entity that should have a power pole built for it
-- 		This function will also destroy any erroneous power poles under this entity, to make place for new ones (only if a different one will need created)
-- This can be nil if there is not an entity to build a power pole for or if it already has a correctly sized power pole
function Actions.checkAreaForEntityToPower(surface, force, area)
	local entities = surface.find_entities_filtered{area=area, force=force}
	local largestEntity, largestPowerPoleSize = Actions.Filters.findLargestEntity(entities)
	
	if largestEntity then
		-- If a larger entity was found, then we are under something and should be looking at the larger entity, so zoom out to it
		local largestEntitySelectionBox = largestEntity["selection_box"]
		if not Util.isEqualBoundingBox(area, largestEntitySelectionBox) then
			Util.traceLog("Found a larger entity, zooming out to " .. largestEntity["name"])
			return Actions.checkAreaForEntityToPower(surface, force, largestEntitySelectionBox)
		end
		
		local foundPowerPad = Actions.Filters.containsPowerPad(entities)
		local foundElectricConsumer = Actions.Filters.containsElectricEntity(entities)
		local foundPowerPoles = Actions.Filters.findPowerPoles(entities)
		
		-- We're on the largest entity and found atleast on electric consumer in the pile and a power pad
		if foundPowerPad and foundElectricConsumer then
			if #foundPowerPoles > 0 then
				Util.traceLog("Found " .. #foundPowerPoles .. " current power poles")
				local doNotBuildNew = false
				
				-- Keep exactly 1 of the correct sized power pole in the center of the entity, if any exist. Destroy all others
				for _, powerPole in ipairs(foundPowerPoles) do
					local powerPoleSize = Entity_Lib.getEntitySizeFromPowerPoleName(powerPole.name)
					if not doNotBuildNew and powerPoleSize == largestPowerPoleSize and Util.isEqualPositions(largestEntity.position, powerPole.position) then
						Util.traceLog("Keeping current power pole")
						doNotBuildNew = true
					else
						powerPole.destroy()
					end
				end
				
				if doNotBuildNew then return nil end
			end
			return largestEntity
		end
	end
	
	if largestEntity and foundElectricConsumer then
	end
end

-- Filtering functions used by actions
Actions.Filters = {}
function Actions.Filters.findLargestEntity(entities)
	local largestEntity
	local largestPowerPoleSize = -1
	for _, entity in pairs(entities) do
		if Entity_Lib.canBePoweredEntity(entity) then
			local foundSize = Entity_Lib.getEntitySize(entity.prototype)
			if foundSize > largestPowerPoleSize then
				largestEntity = entity
				largestPowerPoleSize = foundSize
			end
		end
	end
	
	return largestEntity, largestPowerPoleSize
end

function Actions.Filters.findPowerPoles(entities)
	local powerPoles = {}
	for _, entity in pairs(entities) do
		if string.find(entity.name, Config.INVISIBLE_POLE_BASE_NAME_ESCAPED) then
			table.insert(powerPoles, entity)
		end
	end
	return powerPoles
end

function Actions.Filters.containsElectricEntity(entities)
	for _, entity in pairs(entities) do
		if not string.find(entity.name, Config.INVISIBLE_POLE_BASE_NAME_ESCAPED) then
			if Entity_Lib.isElectricEntity(entity.prototype) then
				return true
			end
		end
	end
	return false
end

function Actions.Filters.containsPowerPad(entities)
	for _, entity in pairs(entities) do
		if entity.name == Config.POWER_PAD_NAME then
			return true
		end
	end
	return false
end

if Config.MANUAL_MODE then
	-- The manual functions call the automatic functions, so the automatic tech check is redundant, since the power pads are relied on instead
	Actions.techCheck = function(f) return true end
else
	-- In automatic mode we don't need the power pads
	Actions.Filters.containsPowerPad = function(e) return true end
end

