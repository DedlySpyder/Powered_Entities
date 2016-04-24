require "defines"
require "config"
require 'stdlib/area/area'

local invisablePowerPoles = {"small-invisable-electric-pole",
								"medium-invisable-electric-pole",
								"large-invisable-electric-pole"}

local allInvisablePowerPoles = {"small-invisable-electric-pole",
								"medium-invisable-electric-pole",
								"large-invisable-electric-pole",
								"power-pad-pole"}				
								
--Check on building entities
function entityBuilt(event)
	debugLog("Build triggered")
	local entity = event.created_entity
	
	--Manual mode
	if manual_mode then
		local positionBox = searchBox(entity)
		local flag
		
		if (entity.name =="power-pad") then
			--Search for entities
			local foundEntities = entity.surface.find_entities(positionBox)
			
			--Try to build a pole
			for _, entityFound in ipairs(foundEntities) do
				--Make sure a machine was found
				if (entityFound.name ~= "power-pad") then
					flag = buildInvisablePole(entityFound, entity.position)
				else debugLog("Found a pad") end
				if flag then break end
			end
			
			--If it could not, create the power pad pole
			if not flag then
				entity.surface.create_entity{name="power-pad-pole", position=entity.position, force=game.players[1].force}
			end
		else
			--Search for power pads
			local foundPowerPads = entity.surface.find_entities_filtered{area=positionBox, name="power-pad"}
			
			--Build power poles
			for _, thisPowerPad in ipairs(foundPowerPads) do
				flag = buildInvisablePole(entity, thisPowerPad.position)
				if flag then debugLog("Built a pole") end
			end
			
			--If it could place a power pole, destroy the default power pole
			if flag then
				destroyEntity(entity, {"power-pad-pole"})
			end
		end
	else --Automatic Mode
		--Check for technology researched
		if (game.player.force.technologies["powered-entities"].researched) then
			buildInvisablePole(entity, entity.position)
		end
	end
end

--Build a power pole
function buildInvisablePole(entity, position)
	
	--On small entities build
	for _, searchEntity in ipairs(smallEntities) do
		debugLog("Searching...small")
		if (searchEntity == entity.name) then
			debugLog("Found small")
			--Build the power pole
			entity.surface.create_entity{name="small-invisable-electric-pole", position=position, force=game.players[1].force}
			return true
		end
	end
	
	--On medium entities build
	for _, searchEntity in ipairs(mediumEntities) do
		debugLog("Searching...med")
		if (searchEntity == entity.name) then
			debugLog("Found med")
			--Build the power pole
			entity.surface.create_entity{name="medium-invisable-electric-pole", position=position, force=game.players[1].force}
			return true
		end
	end

	--On large entities build
	for _, searchEntity in ipairs(largeEntities) do
		debugLog("Searching...large")
		if (searchEntity == entity.name) then
			debugLog("Found large")
			--Build the power pole
			entity.surface.create_entity{name="large-invisable-electric-pole", position=position, force=game.players[1].force}
			return true
		end
	end
	return false
end

--Register events, references the function
script.on_event(defines.events.on_robot_built_entity, entityBuilt)
script.on_event(defines.events.on_built_entity, entityBuilt)

--Check on destroying entities
function entityDestroyed(event)
	local entity = event.entity
	local positionBox = searchBox(entity)
	
	--Manual Mode
	if manual_mode then 
		if (entity.name == "power-pad") then
			--If a pad is found, destroy any poles
			destroyEntity(entity, allInvisablePowerPoles)
		else
			--Otherwise, destroy only the non-power pad poles
			destroyEntity(entity, invisablePowerPoles)
			
			--Search for power pads
			local foundPowerPads = entity.surface.find_entities_filtered{area=positionBox, name="power-pad"}
			for _, powerPad in ipairs(foundPowerPads) do
				debugLog("Found some pads to rebuild default pole")
				--Rebuild the default pole
				entity.surface.create_entity{name="power-pad-pole", position=powerPad.position, force=game.players[1].force}
			end
		end
	else --Automatic Mode
		destroyEntity(entity, invisablePowerPoles)
	end
end

--Destroy power poles around the specified entity, using the array (entitiesToDestroy) to compare to
function destroyEntity(entity, entitiesToDestroy)
	debugLog("Starting to destroy")
	
	local positionBox = searchBox(entity)
	
	--Search for any power poles
	local foundEntities = entity.surface.find_entities_filtered{area=positionBox, type="electric-pole"}
	for _, checkedEntity in ipairs(foundEntities) do
		for _, entityToDestroy in ipairs(entitiesToDestroy) do
			if (checkedEntity.name == entityToDestroy) then 
				--If the found pole is on the list, destroy it
				checkedEntity.destroy()
				break
			end
		end
	end
end

--Register events, references the function
script.on_event(defines.events.on_preplayer_mined_item, entityDestroyed)
script.on_event(defines.events.on_robot_pre_mined, entityDestroyed)
script.on_event(defines.events.on_entity_died, entityDestroyed)

--Internal functions

--Returns a search BoundingBox
function searchBox(entity)
	local entityPrototype = entity.prototype
	local positionBox = entityPrototype.selection_box
	local positionBox = Area.offset(positionBox, entity.position)
	
	return positionBox
end

--Checks if technology is researched (Automatic Mode)
function researchCheck()
	return game.local_player.force.technologies["powered-entities"].researched
end

--Displays debug messages
function debugLog(message)
	if debug_mode then
		game.player.print(message)
	end
end 

--Test function, gives all entities effected by mod and some power poles if needed
-- /c remote.call("PE", "testing")
remote.add_interface("PE", {
	testing = function()
		if debug_mode then 
			for _, item in ipairs(smallEntities) do
				game.player.insert(item)
			end
			for _, item in ipairs(mediumEntities) do
				game.player.insert(item)
			end
			for _, item in ipairs(largeEntities) do
				game.player.insert(item)
			end
			if manual_mode then
				game.player.insert{name="power-pad", count=200}
			end
		end
	end
})