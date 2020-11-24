local mod_gui = require("mod-gui")

require("config")
require("util")

GUI = {}

-- Recalculate button
function GUI.drawRecalculateButton(player)
	if player and player.connected then
		Util.debugLog("Drawing recalculate button for " .. player.name)
		local buttonFlow = mod_gui.get_button_flow(player)
		if not (buttonFlow.poweredEntitiesRecalculateButton and buttonFlow.poweredEntitiesRecalculateButton.valid) then
			if Config.SHOW_RECALCULATE then
				buttonFlow.add{type="button", name="poweredEntitiesRecalculateButton", caption={"Powered-Entities-recalculate-entities-button"}}
			end
		end
	end
end

function GUI.drawRecalculateButtonByForce(force)
	for _, player in pairs(force.players) do
		GUI.drawRecalculateButton(player)
	end
end

function GUI.drawRecalculateButtonAllWhenNeeded()
	for _, force in pairs(game.forces) do
		if force.technologies[Config.TECHNOLOGY_NAME].researched then
			GUI.drawRecalculateButtonByForce(force)
		end
	end
end


function GUI.destroyRecalculateButton(player)
	if player and player.connected then
		Util.debugLog("Destroying recalculate button for " .. player.name)
		local buttonFlow = mod_gui.get_button_flow(player)
		if buttonFlow.poweredEntitiesRecalculateButton and buttonFlow.poweredEntitiesRecalculateButton.valid then
			buttonFlow.poweredEntitiesRecalculateButton.destroy()
		end
	end
end

function GUI.destroyRecalculateButtonAll()
	for _, player in pairs(game.players) do
		GUI.destroyRecalculateButton(player)
	end
end


-- Report Button (debug mode only)
function GUI.toggleReportButtonAll()
	if Config.DEBUG_MODE then
		GUI.drawReportButtonAll()
	else
		GUI.destroyReportButtonAll()
	end
end

function GUI.drawReportButtonAll()
	for _, player in pairs(game.players) do
		Util.debugLog("Drawing report button for " .. player.name)
		local buttonFlow = mod_gui.get_button_flow(player)
		if not (buttonFlow.poweredEntitiesReportButton and buttonFlow.poweredEntitiesReportButton.valid) then
			buttonFlow.add{type="button", name="poweredEntitiesReportButton", caption={"Powered-Entities-report-generation-button"}}
		end
	end
end

function GUI.destroyReportButtonAll()
	for _, player in pairs(game.players) do
		Util.debugLog("Destroying report button for " .. player.name)
		local buttonFlow = mod_gui.get_button_flow(player)
		if buttonFlow.poweredEntitiesReportButton and buttonFlow.poweredEntitiesReportButton.valid then
			buttonFlow.poweredEntitiesReportButton.destroy()
		end
	end
end
