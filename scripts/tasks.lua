-- Requires the following to be loaded at some point as well, but there are circular dependencies there
--		Actions
--		Report
require("util")

--[[
Tasks.scheduleTask(...) is used to fire off a function sometime in the future

This class will override the on_tick handler for the entire mod, and will nil it out when there are no tasks being run, so will not waste resources
]]--

Tasks = {}

Tasks.SCHEDULER_RUNNING = false

function Tasks.init()
	global.scheduledTasks = global.scheduledTasks or {}
	global.ephemeralTasks = global.ephemeralTasks or {}
	global.runningTasks = global.runningTasks or 0
	
	Tasks.reloadTaskMapping()
end

function Tasks.onLoad()
	Tasks.reloadTaskMapping()
	Tasks.attemptToStartScheduler()
end

function Tasks.reloadTaskMapping()
	Util.traceLog("Reloading task mapping")
	Tasks.TASK_MAPPING = {
		onBuild = Actions.onBuild,
		onDestroy = Actions.onDestroy,
		regenerationComplete = Actions.regenerationComplete,
		regeneratePowerPoles = Actions.regeneratePowerPolesTask,
		reportCleanup = Report.cleanup
	}
end

function Tasks.attemptToStartScheduler()
	if not Tasks.SCHEDULER_RUNNING and global.runningTasks and global.runningTasks > 0 then
		Util.debugLog("Starting scheduler")
		script.on_event(defines.events.on_tick, Tasks.scheduler)
		Tasks.SCHEDULER_RUNNING = true
	end
end

-- Arguments:
--	- name			- unique name to this task (sequential tasks scheduled for the same name will overwrite each other)
--	- actionName	- a name of a task to run from Tasks.TASK_MAPPING
--	- args			- a list of args for the function, they will be entered into the function in order (look up `unpack` for more info)
--	- delay			- number of ticks to delay from this point, optional will default to 1 tick if not provided or if it is 0 or less
function Tasks.scheduleTask(name, actionName, args, delay)
	if not delay or delay <= 0 then
		delay = 1
	end
	
	if not global.scheduledTasks[name] then
		Util.traceLog("Adding task " .. name .. " for the first time with delay " .. delay)
		global.runningTasks = global.runningTasks + 1
	end
	
	-- Either add the task, or update the delay with the new time
	global.scheduledTasks[name] = {action=actionName, args=args, startTime=game.tick + delay}
	
	Tasks.attemptToStartScheduler()
end

-- Same as Tasks.scheduleTask, but supplying a function instead of a name to lookup
-- These are assumed to not be needed after a save/load cycle (mainly for report tasks)
function Tasks.scheduleEphemeralTask(name, actionFunc, args, delay)
	if not delay or delay <= 0 then
		delay = 1
	end
	
	if not global.ephemeralTasks[name] then
		Util.traceLog("Adding ephemeral task " .. name .. " for the first time with delay " .. delay)
		global.runningTasks = global.runningTasks + 1
	end
	
	-- Either add the task, or update the delay with the new time
	global.ephemeralTasks[name] = {action=actionFunc, args=args, startTime=game.tick + delay}
	
	Tasks.attemptToStartScheduler()
end

function Tasks.scheduler(event)
	local completedActions = 0
	for name, task in pairs(global.scheduledTasks) do
		if task["startTime"] == game.tick then
			local action = task["action"]
			Util.traceLog("Running task " .. name .. " using action " .. action)
			Tasks.TASK_MAPPING[action](unpack(task["args"]))
			
			task["done"] = true
			completedActions = completedActions + 1
		end
	end
	
	for name, task in pairs(global.ephemeralTasks) do
		if task["startTime"] == game.tick then
			local action = task["action"]
			if action then
				Util.traceLog("Running ephemeral task " .. name)
				action(unpack(task["args"]))
			else
				Util.traceLog("WARN: Ephemeral task " .. name .. " is non-existent")
			end
			
			task["done"] = true
			completedActions = completedActions + 1
		end
	end
	
	if completedActions > 0 then
		Util.traceLog("Removing " .. completedActions .. " tasks from scheduler")
		global.scheduledTasks = Util.filterTable(global.scheduledTasks, function(v) return not v["done"] end)
		global.runningTasks = global.runningTasks - completedActions
	end
	
	if global.runningTasks == 0 then
		Util.debugLog("No more events found, removing scheduler")
		script.on_event(defines.events.on_tick, nil)
		Tasks.SCHEDULER_RUNNING = false
	end
end

function Tasks.uniqueNameForEntity(entity)
	return game.tick .. "-" .. entity.surface.name .. "-" .. entity.name .. "-(" .. entity.position.x .. "," .. entity.position.y .. ")"
end

function Tasks.uniqueNameForChunk(surface, chunk)
	return surface.name .. "-" .. chunk.x .. "," .. chunk.y
end
