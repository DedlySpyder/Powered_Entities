require("config")

Util = {}

-- Logger that works in both the data stage and during gameplay
if Config.DEBUG_MODE and Config.DEBUG_TYPE == "console" then
	Util.debugLog = function(message)
		if game then
			for _, player in pairs(game.players) do
				if player and player.valid then
					player.print("[" .. game.tick .. "] " .. message)
				end
			end
		else
			log(message)
		end
	end
elseif Config.DEBUG_MODE and Config.DEBUG_TYPE == "file" then
	Util.debugLog = log
else
	Util.debugLog = function(m) end
end

-- Trace is way too verbose for console logging
if Config.TRACE_MODE then
	Util.traceLog = log
else
	Util.traceLog = function(m) end
end

function Util.printAll(message)
	for _, player in pairs(game.players) do
		if player.valid and player.connected then
			player.print(message)
		end
	end
end

-- Filter either a table or an array, if the function returns true then the value will stay
function Util.filterTable(tbl, func)
	local newTable = {}
	local isArr = #tbl > 0
	for k, v in pairs(tbl) do
		if func(v) then
			if isArr then
				table.insert(newTable, v)
			else
				newTable[k] = v
			end
		end
	end
	return newTable
end

-- Standardize
function Util.standardizeBoundingBox(boundingBox)
	if not boundingBox or boundingBox.left_top and boundingBox.right_bottom then
		return boundingBox
	end
	
	return {
		left_top = Util.standardizePosition(boundingBox[1]),
		right_bottom = Util.standardizePosition(boundingBox[2])
	}
end

function Util.standardizePosition(position)
	if not position or position.x and position.y then
		return position
	end
	
	return {x = position[1], y = position[2]}
end

-- Comparison
function Util.isEqualBoundingBox(box1, box2, skipStandardize)
	if not skipStandardize then
		box1 = Util.standardizeBoundingBox(box1)
		box2 = Util.standardizeBoundingBox(box2)
	end
	
	return Util.isEqualPositions(box1.left_top, box2.left_top, true) and Util.isEqualPositions(box1.right_bottom, box2.right_bottom, true)
end

function Util.isEqualPositions(pos1, pos2, skipStandardize)
	if not skipStandardize then
		pos1 = Util.standardizePosition(pos1)
		pos2 = Util.standardizePosition(pos2)
	end
	
	return pos1.x == pos2.x and pos1.y == pos2.y
end

-- Resizing
-- NOTE: Rounds up (or down if negative) all resulting values
function Util.positionToBoundingBox(position, selectionBox, skipStandardize)
	if not skipStandardize then
		position = Util.standardizePosition(position)
		selectionBox = Util.standardizeBoundingBox(selectionBox)
	end
	
	if position and selectionBox then
		for _, boxPart in pairs(selectionBox) do
			for key, subPosititon in pairs(boxPart) do
				boxPart[key] = subPosititon + position[key]
				
				local value = boxPart[key]
				if value < 0 then
					boxPart[key] = math.floor(value)
				else
					boxPart[key] = math.ceil(value)
				end
			end
		end
	end
	
	return selectionBox
end
