require("util")


Migrations = {}

function Migrations.handle(data)
	if data.mod_changes and data.mod_changes["Powered_Entities"] then
		local oldVersion = data.mod_changes["Powered_Entities"].old_version
		if oldVersion then
			if Migrations.versionCompare(oldVersion, "0.3.0") then
				Migrations.to_0_3_0()
			end
			if Migrations.versionCompare(oldVersion, "0.4.0") then
				Migrations.to_0_4_0()
			end
			if Migrations.versionCompare(oldVersion, "0.5.0") then
				Migrations.to_0_5_0()
			end
		end
	end
end

-- Returns true if oldVersion is older than newVersion
function Migrations.versionCompare(oldVersion, newVersion)
	_, _, oldMaj, oldMin, oldPat = string.find(oldVersion, "(%d+)%.(%d+)%.(%d+)")
	_, _, newMaj, newMin, newPat = string.find(newVersion, "(%d+)%.(%d+)%.(%d+)")
	
	local lt = function(o, n) return tonumber(o) < tonumber(n) end
	local gt = function(o, n) return tonumber(o) > tonumber(n) end
	
	if gt(oldMaj, newMaj) then return false
	elseif lt(oldMaj, newMaj) then return true end
	
	if gt(oldMin, newMin) then return false
	elseif lt(oldMin, newMin) then return true end
	
	if lt(oldPat, newPat) then return true end
	return false
end

function Migrations.to_0_3_0()
	if Config.MANUAL_MODE then
		-- This is needed because json migration does not work for technologies in 0.12
		for _, force in pairs(game.forces) do
			if force.recipes["power-pad"].enabled then
				force.technologies["powered-entities"].researched = true
			end
		end
	end
end

function Migrations.to_0_4_0()
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

-- Actions changed from the function to a string representing the function to lookup
function Migrations.to_0_5_0()
	local surfaces = {}
	for _, surface in pairs(game.surfaces) do
		table.insert(surfaces, surface.name)
	end
	
	local reportInProgress = false
	for name, task in pairs(global.scheduledTasks) do
		if string.find(name, "Powered_Entities_report") or string.find(name, "report%-schedule%-tasks") or string.find(name, "report%-generation") then
			-- The onBuild/onDestroy for the report
			Util.traceLog("Mid progress report tasks have been discarded: " .. name)
			global.scheduledTasks[name] = nil
			reportInProgress = true
		
		elseif string.match(name, "^%d+") then
			-- "[tick]-..." is the onBuild/onDestroy, but onDestroy will attempt to do both
			Util.traceLog("Migrating " .. name .. " to onDestroy")
			task["action"] = "onDestroy"
			
			-- Shift the args
			--	old - {nil - func, entity, entity.name, entity.surface, entity.force, entity.selection_box}
			--	new - {entity, entity.name, entity.surface, entity.force, entity.selection_box}
			local args = task["args"]
			local tempArgs = {}
			for i=2,6 do
				tempArgs[i-1] = args[i]
			end
			task["args"] = tempArgs
			
		elseif name == "regeneration-complete" then
			Util.traceLog("Migrating " .. name .. " to regenerationComplete")
			task["action"] = "regenerationComplete"
			
		else
			local found = false
			for _, surface in ipairs(surfaces) do
				if string.match(name, "^" .. surface) then
					Util.traceLog("Migrating " .. name .. " to regeneratePowerPoles")
					task["action"] = "regeneratePowerPoles"
					found = true
					break
				end
			end
			
			if not found then
				Util.traceLog("Task " .. name .. " was not migrated succesfully")
			end
		end
	end
	
	if reportInProgress then
		Report.cleanup()
	end
	
	global.runningTasks = table_size(global.scheduledTasks)
	
	-- Re-init for the ephemeral table
	Tasks.init()
end
