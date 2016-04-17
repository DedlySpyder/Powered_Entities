require "defines"
require "config"
require 'stdlib/area/area'

local invisablePowerPoles = {"small-invisable-electric-pole",
								"medium-invisable-electric-pole",
								"large-invisable-electric-pole"}

local allPowerPoles = {"small-invisable-electric-pole",
								"medium-invisable-electric-pole",
								"large-invisable-electric-pole",
								"power-pad-pole"}				
								
--Check on building entities
function entityBuilt(event)
	debugLog("Build triggered")
	local entity = event.created_entity
	
	if manual_mode then
		local positionX = entity.position.x
		local positionY = entity.position.y
		
		local entityPrototype = entity.prototype
		local positionBox = entityPrototype.selection_box
		
		local positionBox = Area.offset(positionBox, entity.position)
		
		if (entity.name =="power-pad") then
			local foundEntities = entity.surface.find_entities(positionBox)
			local flag
			--Try to build a pole
			for _, entityFound in ipairs(foundEntities) do
				flag = buildInvisablePole(entityFound, entity.position)
				if flag then break end
			end
			--If it could not, create the power pad pole
			if not flag then
				entity.surface.create_entity{name="power-pad-pole", position=entity.position, force=game.players[1].force}
			end
		else
			local foundPowerPads = entity.surface.find_entities_filtered{area=positionBox, name="power-pad"}			
			local flag
			for _, thisPowerPad in ipairs(foundPowerPads) do
				flag = buildInvisablePole(entity, thisPowerPad.position)
				if flag then debugLog("true") end
			end
			if flag then
				destroyEntity(entity, {"power-pad-pole"})
			end
		end
	else
		if (game.player.force.technologies["powered-entities"].researched) then
			buildInvisablePole(entity, entity.position)
		end
	end
end


function buildInvisablePole(entity, position)
	
	if (entity.name == "power-pad") then
		debugLog("Found a pad")
		return false
	end
	
	for _, searchEntity in ipairs(smallEntities) do
		debugLog("Searching...small")
		if (searchEntity == entity.name) then
			debugLog("Found small")
			
			entity.surface.create_entity{name="small-invisable-electric-pole", position=position, force=game.players[1].force}
			return true
		end
	end
	
	for _, searchEntity in ipairs(mediumEntities) do
		debugLog("Searching...med")
		if (searchEntity == entity.name) then
			debugLog("Found med")
			
			entity.surface.create_entity{name="medium-invisable-electric-pole", position=position, force=game.players[1].force}
			return true
		end
	end

	for _, searchEntity in ipairs(largeEntities) do
		debugLog("Searching...large")
		if (searchEntity == entity.name) then
			debugLog("Found large")
			
			entity.surface.create_entity{name="large-invisable-electric-pole", position=position, force=game.players[1].force}
			return true
		end
	end
	return false
end

script.on_event(defines.events.on_robot_built_entity, entityBuilt)
script.on_event(defines.events.on_built_entity, entityBuilt)

--Check on destroying entities ************************I imagine this would be the problem with the bug, if it were my mod
function entityDestroyed(event)
	local entity = event.entity
	local entityPrototype = entity.prototype
	local positionBox = entityPrototype.selection_box
	positionBox = Area.offset (positionBox, entity.position)
	
	--If a pad is found, destroy any poles
	if manual_mode then 
		if (entity.name == "power-pad") then
			destroyEntity(entity, allPowerPoles)
		else
			destroyEntity(entity, invisablePowerPoles)
			
			local foundPowerPads = entity.surface.find_entities_filtered{area=positionBox, name="power-pad"}
			for _, powerPad in ipairs(foundPowerPads) do
				debugLog("Found some pads to rebuild poles")
				entity.surface.create_entity{name="power-pad-pole", position=powerPad.position, force=game.players[1].force}
			end
		end
	else
		destroyEntity(entity, invisablePowerPoles)
	end
end

--"entity" is used only for the position and size of search area
function destroyEntity(entity, entitiesToDestroy)
	debugLog("Starting to destroy")
		
	local entityPrototype = entity.prototype
	local positionBox = entityPrototype.selection_box
	
	positionBox = Area.offset (positionBox, entity.position)
		
	local foundEntities = entity.surface.find_entities_filtered{area=positionBox, type="electric-pole"}
	for _, checkedEntity in ipairs(foundEntities) do
		for _, entityToDestroy in ipairs(entitiesToDestroy) do
			if (checkedEntity.name == entityToDestroy) then 
				checkedEntity.destroy()
				break
			end
		end
	end
end

script.on_event(defines.events.on_preplayer_mined_item, entityDestroyed)
script.on_event(defines.events.on_robot_pre_mined, entityDestroyed)
script.on_event(defines.events.on_entity_died, entityDestroyed)

function researchCheck()
	return game.local_player.force.technologies["powered-entities"].researched
end

function debugLog(message)
	if debug_mode then
		game.player.print(message)
	end
end 

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