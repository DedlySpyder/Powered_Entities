require "config"
require "scripts"
require "mod-compadibility/mod-compadibility"
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
		if data.mod_changes["Powered_Entities"].old_version < "0.3.8" then
			for _, force in pairs(game.forces) do
				if force.technologies["powered-entities"].researched then
					for _, player in pairs(force.players) do
						drawRecalculateButton(player)
					end
				end
			end
		end
	end
	initializeGlobal()
end)

script.on_init(function(data)
	initializeGlobal()
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

--Check on research completed
function researchCompleted(event)
	local tech = event.research
	
	--Check for the tech, and if in automatic mode
	if (tech.name == "powered-entities") then
		drawRecalculateButtonAll()
		
		if not manual_mode then
			placeAllPolesAutomatic(tech.force)
		end
	end
end

--Check when a player connects to a game
function on_player_connected(event)
	local player = game.players[event.player_index]
	if player.force.technologies["powered-entities"].researched then
		drawRecalculateButton(player)
	end
end

--Check when a player clicks a GUI button
function on_button_click(event)
	if (event.element.name == "poweredEntitiesRecalculateButton") then
		initializeGlobal()
		
		if manual_mode then
			placeAllPolesManual()
		else
			placeAllPolesAutomatic(nil)
		end
	end
end

--Register event handlers
script.on_event(defines.events.on_robot_built_entity, entityBuilt)
script.on_event(defines.events.on_preplayer_mined_item, entityDestroyed)
script.on_event(defines.events.on_robot_pre_mined, entityDestroyed)
script.on_event(defines.events.on_entity_died, entityDestroyed)
script.on_event(defines.events.on_research_finished, researchCompleted)
script.on_event(defines.events.on_player_joined_game, on_player_connected)
script.on_event(defines.events.on_built_entity, entityBuilt)
script.on_event(defines.events.on_gui_click, on_button_click)

--Displays debug messages
function debugLog(message)
	if debug_mode then
		for _, player in pairs(game.players) do
			player.print(message)
		end
	end
end 

--Remote Calls
remote.add_interface("Powered_Entities", {
	--This is a command to switch between modes after a game has already had this mod run on it
	--It will also recheck the config files
	-- /c remote.call("Powered_Entities", "Recalculate_Powered_Entities")
	Recalculate_Powered_Entities = function()
		initializeGlobal()
		
		if manual_mode then
			placeAllPolesManual()
		else
			placeAllPolesAutomatic(nil)
		end
	end,

	--Test function, gives all entities effected by mod and some power poles if needed
	-- /c remote.call("Powered_Entities", "debug_testing")
	debug_testing = function()
		if debug_mode then 
			for _, player in pairs(game.players) do
				for _, item in pairs(entities1x1) do
					player.insert(item)
				end
				for _, item in pairs(entities2x2) do
					player.insert(item)
				end
				for _, item in pairs(entities3x3) do
					player.insert(item)
				end
				for _, item in pairs(entities4x4) do
					player.insert(item)
				end
				for _, item in pairs(entities5x5) do
					player.insert(item)
				end
				for _, item in pairs(entities9x10) do
					player.insert(item)
				end
				for _, item in pairs(entitiesCustom) do
					player.insert(item)
				end
				if manual_mode then
					player.insert{name="power-pad", count=200}
				end
			end
		end
	end,
	
	--Exports arrays to file
	-- /c remote.call("Powered_Entities", "debug_export_arrays")
	debug_export_arrays = function()
		if debug_mode then
			game.write_file("Powered_Entities_Export.txt", "", false)
			game.write_file("Powered_Entities_Export.txt", "1x1\r\n", true)
			for _, item in pairs(entities1x1) do
				game.write_file("Powered_Entities_Export.txt", item.."\r\n", true)
			end
			game.write_file("Powered_Entities_Export.txt", "2x2\r\n", true)
			for _, item in pairs(entities2x2) do
				game.write_file("Powered_Entities_Export.txt", item.."\r\n", true)
			end
			game.write_file("Powered_Entities_Export.txt", "3x3\r\n", true)
			for _, item in pairs(entities3x3) do
				game.write_file("Powered_Entities_Export.txt", item.."\r\n", true)
			end
			game.write_file("Powered_Entities_Export.txt", "4x4\r\n", true)
			for _, item in pairs(entities4x4) do
				game.write_file("Powered_Entities_Export.txt", item.."\r\n", true)
			end
			game.write_file("Powered_Entities_Export.txt", "5x5\r\n", true)
			for _, item in pairs(entities5x5) do
				game.write_file("Powered_Entities_Export.txt", item.."\r\n", true)
			end
			game.write_file("Powered_Entities_Export.txt", "9x10\r\n", true)
			for _, item in pairs(entities9x10) do
				game.write_file("Powered_Entities_Export.txt", item.."\r\n", true)
			end
			game.write_file("Powered_Entities_Export.txt", "Custom\r\n", true)
			for _, item in pairs(entitiesCustom) do
				game.write_file("Powered_Entities_Export.txt", item.."\r\n", true)
			end
		end
	end
})