require "config"
require "scripts"
require "mod-compadibility"
require 'stdlib/area/area'
require 'stdlib/surface'
require 'stdlib/game'

invisablePowerPoles = {	"invisable-electric-pole-1x1",
						"invisable-electric-pole-2x2",
						"invisable-electric-pole-3x3",
						"invisable-electric-pole-4x4",
						"invisable-electric-pole-5x5",
						"invisable-electric-pole-9x10",
						"invisable-electric-pole-custom"}

allInvisablePowerPoles = {	"invisable-electric-pole-1x1",
							"invisable-electric-pole-2x2",
							"invisable-electric-pole-3x3",
							"invisable-electric-pole-4x4",
							"invisable-electric-pole-5x5",
							"invisable-electric-pole-9x10",
							"invisable-electric-pole-custom",
							"power-pad-pole"}				
								

--Handles the version change to 0.3.0
script.on_configuration_changed(function(data)
	if data.mod_changes ~= nil and data.mod_changes["Powered_Entities"] ~= nil and data.mod_changes["Powered_Entities"].old_version ~= nil then
		if data.mod_changes["Powered_Entities"].old_version < "0.3.0" then
			if manual_mode then
				--This is needed because json migration does not work for technologies in 0.12
				for _, force in pairs(game.forces) do
					if force.recipes["power-pad"].enabled then
						force.technologies["powered-entities"].researched = true
					end
				end
				
				placeAllPolesManual()
			else
				placeAllPolesAutomatic(nil)
			end
		end
	end
end)

script.on_init(function(data)
	initialize_arrays()
end)
 
 --Check on building entities
function entityBuilt(event)
	debugLog("Build triggered")
	local entity = event.created_entity
	
	--Manual mode
	if manual_mode then
		manualModeOnBuild(entity)
	else --Automatic Mode
		--Check for technology researched
		if (entity.force.technologies["powered-entities"].researched) then
			buildInvisablePole(entity)
		end
	end
end

--Register events, references the function
script.on_event(defines.events.on_robot_built_entity, entityBuilt)
script.on_event(defines.events.on_built_entity, entityBuilt)

--Check on destroying entities
function entityDestroyed(event)
	local entity = event.entity
	
	--Manual Mode
	if manual_mode then 
		manualModeOnDestroy(entity)
		
	--Automatic Mode
	else
		destroyEntity(entity, invisablePowerPoles)
	end
end

--Register events, references the function
script.on_event(defines.events.on_preplayer_mined_item, entityDestroyed)
script.on_event(defines.events.on_robot_pre_mined, entityDestroyed)
script.on_event(defines.events.on_entity_died, entityDestroyed)

--Check on research completed
function researchCompleted(event)
	local tech = event.research
	
	--Check for the tech, and if in automatic mode
	if (tech.name == "powered-entities" and not manual_mode) then
		placeAllPolesAutomatic(tech.force)
	end
end

--Register events, references the function
script.on_event(defines.events.on_research_finished, researchCompleted)

--Displays debug messages
function debugLog(message)
	if debug_mode then
		game.player.print(message)
	end
end 

--Remote Calls

--This is a command to switch between modes after a game has already had this mod run on it
-- /c remote.call("Powered_Entities", "Recalculate_Powered_Entities")
remote.add_interface("Powered_Entities", {
	Recalculate_Powered_Entities = function()
		if manual_mode then
			placeAllPolesManual()
		else
			placeAllPolesAutomatic(nil)
		end
	end
})

--Test function, gives all entities effected by mod and some power poles if needed
-- /c remote.call("PE", "testing")
remote.add_interface("PE", {
	testing = function()
		if debug_mode then 
			for _, item in pairs(entities1x1) do
				game.player.insert(item)
			end
			for _, item in pairs(entities2x2) do
				game.player.insert(item)
			end
			for _, item in pairs(entities3x3) do
				game.player.insert(item)
			end
			for _, item in pairs(entities4x4) do
				game.player.insert(item)
			end
			for _, item in pairs(entities5x5) do
				game.player.insert(item)
			end
			for _, item in pairs(entities9x10) do
				game.player.insert(item)
			end
			for _, item in pairs(entitiesCustom) do
				game.player.insert(item)
			end
			if manual_mode then
				game.player.insert{name="power-pad", count=200}
			end
		end
	end
})