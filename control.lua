require("scripts/actions")
require("scripts/config")
require("scripts/gui")
require("scripts/report")
require("scripts/tasks")
require("scripts/util")


script.on_configuration_changed(function(data)
	if data.mod_changes and data.mod_changes["Powered_Entities"] and data.mod_changes["Powered_Entities"].old_version then
		if data.mod_changes["Powered_Entities"].old_version < "0.3.0" then
			if Config.MANUAL_MODE then
				-- This is needed because json migration does not work for technologies in 0.12
				for _, force in pairs(game.forces) do
					if force.recipes["power-pad"].enabled then
						force.technologies["powered-entities"].researched = true
					end
				end
			end
		end
		
		if data.mod_changes["Powered_Entities"].old_version < "0.4.0" then
			-- This first one isn't used any more
			global.poweredEntities = nil
			
			-- Tasks was reworked, so any old tasks will break (it was only being used on a regenerate before anyways)
			global.scheduledTasks = nil
			global.runningTasks = nil
			global.wasInManualMode = not Config.MANUAL_MODE -- Force a recipe check
			
			for _, player in pairs(game.players) do
				if player.gui.top.poweredEntitiesRecalculateButton and player.gui.top.poweredEntitiesRecalculateButton.valid then
					player.gui.top.poweredEntitiesRecalculateButton.destroy()
				end
			end
			GUI.drawRecalculateButtonAllWhenNeeded()
			
			Tasks.init()
			Actions.init()
			Actions.regeneratePowerPoles()
		end
	end
	
	if data.mod_startup_settings_changed then
		-- Manual/Automatic swap
		if global.wasInManualMode ~= Config.MANUAL_MODE then
			Util.debugLog("Manual mode swap, new value: " .. tostring(Config.MANUAL_MODE))
			Actions.regeneratePowerPoles()
			for _, force in pairs(game.forces) do
				if force.technologies[Config.TECHNOLOGY_NAME].researched then
					force.recipes[Config.POWER_PAD_NAME].enabled = Config.MANUAL_MODE
				end
			end
			
			global.wasInManualMode = Config.MANUAL_MODE
		end
		
		-- Report button
		GUI.toggleReportButtonAll()
	end
	
	-- When another mod is added/removed/upgraded, run a regenerate
	if data.mod_changes then
		-- This is just an empty table most of the time, not nil like I expected
		local modSize = table_size(data.mod_changes)
		if modSize ~= 0 and (modSize > 2 or not data.mod_changes["Powered_Entities"]) then
		Util.debugLog("Other mod activity, running regenerate")
		Actions.regeneratePowerPoles()
		end
	end
end)

function register_remote_events(data)
	if remote.interfaces["picker"] and remote.interfaces["picker"]["dolly_moved_entity_id"] then
		function on_picker_dollies_moved(event)
			local entity = event.moved_entity
			on_entity_destroyed({ entity = entity })
			on_entity_built({ created_entity = entity  })						
		end
		
		local eventID = remote.call("picker", "dolly_moved_entity_id")
		if type(eventID) == "number" then
			script.on_event(eventID, on_picker_dollies_moved)
		end
	end
end

script.on_init(function(data)
	Tasks.init()
	Actions.init()
	register_remote_events(data)
end)

script.on_load(function(data)
	Tasks.attemptToStartScheduler()
	register_remote_events(data)
end)


function on_entity_built(event)
	local entity = event.created_entity or event.entity or event.destination
	if entity and entity.valid and not Entity_Lib.isBlacklistedType(entity) then
		Actions.onBuild(entity)
	end
end

script.on_event(defines.events.on_robot_built_entity, on_entity_built)
script.on_event(defines.events.on_built_entity, on_entity_built)
script.on_event(defines.events.on_entity_cloned, on_entity_built)
script.on_event(defines.events.script_raised_built, on_entity_built)
script.on_event(defines.events.script_raised_revive, on_entity_built)

function on_entity_destroyed(event)
	Actions.onDestroy(event.entity)
end

script.on_event(defines.events.on_pre_player_mined_item, on_entity_destroyed)
script.on_event(defines.events.on_robot_pre_mined, on_entity_destroyed)
script.on_event(defines.events.on_entity_died, on_entity_destroyed)
script.on_event(defines.events.script_raised_destroy, on_entity_destroyed)

function on_research_completed(event)
	local tech = event.research
	
	if tech.name == Config.TECHNOLOGY_NAME then
		GUI.drawRecalculateButtonByForce(tech.force)
		
		-- Automatic mode
		if not Config.MANUAL_MODE then
			Actions.regeneratePowerPoles(tech.force)
			tech.force.recipes[Config.POWER_PAD_NAME].enabled = false
		end
	end
end

script.on_event(defines.events.on_research_finished, on_research_completed)

function on_player_joined_force(event)
	local player = game.players[event.player_index]
	if player.force.technologies[Config.TECHNOLOGY_NAME].researched then
		GUI.drawRecalculateButton(player)
	end
	
	GUI.toggleReportButtonAll()
end

script.on_event(defines.events.on_player_joined_game, on_player_joined_force)
script.on_event(defines.events.on_player_created, on_player_joined_force)
script.on_event(defines.events.on_player_changed_force, on_player_joined_force)

function on_button_click(event)
	local elementName = event.element.name
	if elementName == "poweredEntitiesRecalculateButton" then
		Actions.regeneratePowerPoles()
	elseif elementName == "poweredEntitiesReportButton" then
		Report.buildReport()
	end
end

script.on_event(defines.events.on_gui_click, on_button_click)

function on_hotkey_press(event)
	local player = game.players[event.player_index]
	if player and player.valid and player.force and player.force.valid then
		Actions.regeneratePowerPoles(player.force)
	end
end

script.on_event("Powered_Entities_recalculate", on_hotkey_press)

function on_setting_changed(event)
	local setting = event.setting
	if string.find(setting, "Powered_Entities_") then
		Config.refresh()
		
		if setting == Config.SHOW_RECALCULATE_NAME then
			if Config.SHOW_RECALCULATE then
				GUI.drawRecalculateButtonAllWhenNeeded()
			else
				GUI.destroyRecalculateButtonAll()
			end
		elseif string.find(setting, "_enable_") then
			Util.debugLog("Enabled/Disabled entities changed")
			Entity_Lib.init()
			Actions.regeneratePowerPoles()
		end
	end
end

script.on_event(defines.events.on_runtime_mod_setting_changed, on_setting_changed)

remote.add_interface("Powered_Entities", {
	-- Builds the report file in __factorio__/script-output
	-- The report will show which entities will be powered or not by this mod
	-- /c remote.call("Powered_Entities", "build_report")
	build_report = function()
		Report.buildReport()
	end,
	
	-- These 2 are no longer needed, but I don't want to break mods that do call them, so they will exist as no-op functions
	Recalculate_Powered_Entities = function() Util.debugLog("Recalculate remote (no-op) called") end,
	add = function(entity_name, entity_type) Util.debugLog("Add remote (no-op) called with entity name/type " .. entity_name .. "/" .. entity_type) end
})
