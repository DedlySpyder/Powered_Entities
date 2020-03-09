require("scripts/config")
require("scripts/entity_lib")
require("scripts/util")

--[[
On the data side of the invisible power poles, I need to make sure that any entity size in the game has a valid power pole to go with it
In case another mod is doing something with hidden a entity under another entity
]]--

local basePole = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
basePole["flags"] = {"placeable-player", "placeable-off-grid", "not-blueprintable", "not-deconstructable", "not-on-map", "hidden", "hide-alt-info", "not-flammable", "no-copy-paste", "not-selectable-in-game", "not-upgradable"}
basePole["collision_box"] = {{-0, -0}, {0, 0}}
basePole["collision_mask"] = {}
basePole["selection_box"] = nil
basePole["order"] = "z"
basePole["max_health"] = 2147483648
basePole["pictures"] = {
	filename = "__Powered_Entities__/graphics/invisible_power_pole.png",
	width = 1,
	height = 1,
	direction_count = 1
}
basePole["connection_points"] = {
	{
		shadow = {
			copper = {0, -0.2},
			red = {0, 0},
			green = {0, 0}
		},
		wire = {
			copper = {0, -0.2},
			red = {0, 0},
			green = {0, 0}
		}
	}
}

entitySizes = {}
for _, entities in pairs(data.raw) do
	for name, data in pairs(entities) do
		size = Entity_Lib.getEntitySize(data)
		if size then
			entitySizes[tostring(size)] = true
			
			Util.debugLog("Calculated " .. size .. " sized invisible power pole for " .. name)
		end
	end
end

for size, _ in pairs(entitySizes) do
	size = tonumber(size)
	pole = util.table.deepcopy(basePole)
	
	pole["name"] = Config.INVISIBLE_POLE_BASE_NAME .. size
	pole["supply_area_distance"] = (size / 2) + 1
	if Config.MINIMUM_WIRE_REACH then
		pole["maximum_wire_distance"] = math.max(1, size)
	else
		pole["maximum_wire_distance"] = math.max(5, math.floor(size * 1.5))
	end
	
	Util.debugLog("Creating invisible power pole size " .. size .. ":")
	Util.debugLog("Name: " .. pole["name"])
	Util.debugLog("Supply Area: " .. pole["supply_area_distance"])
	Util.debugLog("Max Wire Dist: " .. pole["maximum_wire_distance"])
	
	data:extend({pole})
end
