local invisableElectricPole1x1 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
local invisableElectricPole2x2 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
local invisableElectricPole3x3 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
local invisableElectricPole4x4 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
local invisableElectricPole5x5 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
local invisableElectricPole6x6 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
local invisableElectricPole7x7 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
local invisableElectricPole8x8 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
local invisableElectricPole9x9 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
local invisableElectricPole9x10 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
local invisableElectricPole10x10 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
local invisableElectricPole12x12 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])

local flags = {"placeable-player", "player-creation", "placeable-off-grid", "not-blueprintable", "not-deconstructable", "not-on-map"}
local collisionBox = {{-0, -0}, {0, 0}}
local collisionMask = {"ghost-layer"}
local pictures = {
				  filename = "__Powered_Entities__/graphics/invisible_power_pole.png",
				  width = 1,
				  height = 1,
				  direction_count = 1
				 }
local connectionPoints = {
  {
	shadow =
	{
	  copper = {0, -0.2},
	  red = {0, 0},
	  green = {0, 0}
	},
	wire =
	{
	  copper = {0, -0.2},
	  red = {0,0},
	  green = {0,0}
	}
  }
}

invisableElectricPole1x1.name = "invisable-electric-pole-1x1"
invisableElectricPole2x2.name = "invisable-electric-pole-2x2"
invisableElectricPole3x3.name = "invisable-electric-pole-3x3"
invisableElectricPole4x4.name = "invisable-electric-pole-4x4"
invisableElectricPole5x5.name = "invisable-electric-pole-5x5"
invisableElectricPole6x6.name = "invisable-electric-pole-6x6"
invisableElectricPole7x7.name = "invisable-electric-pole-7x7"
invisableElectricPole8x8.name = "invisable-electric-pole-8x8"
invisableElectricPole9x9.name = "invisable-electric-pole-9x9"
invisableElectricPole9x10.name = "invisable-electric-pole-9x10"
invisableElectricPole10x10.name = "invisable-electric-pole-10x10"
invisableElectricPole12x12.name = "invisable-electric-pole-12x12"


invisableElectricPole1x1.supply_area_distance = 1.5
invisableElectricPole2x2.supply_area_distance = 2
invisableElectricPole3x3.supply_area_distance = 2.5
invisableElectricPole4x4.supply_area_distance = 3
invisableElectricPole5x5.supply_area_distance = 3.5
invisableElectricPole6x6.supply_area_distance = 4
invisableElectricPole7x7.supply_area_distance = 4.5
invisableElectricPole8x8.supply_area_distance = 5
invisableElectricPole9x9.supply_area_distance = 5.5
invisableElectricPole9x10.supply_area_distance = 5.5
invisableElectricPole10x10.supply_area_distance = 6
invisableElectricPole12x12.supply_area_distance = 7


if minimum_wire_reach then
	invisableElectricPole1x1.maximum_wire_distance = 1
	invisableElectricPole2x2.maximum_wire_distance = 2
	invisableElectricPole3x3.maximum_wire_distance = 3
	invisableElectricPole4x4.maximum_wire_distance = 4
	invisableElectricPole5x5.maximum_wire_distance = 5
	invisableElectricPole6x6.maximum_wire_distance = 6
	invisableElectricPole7x7.maximum_wire_distance = 7
	invisableElectricPole8x8.maximum_wire_distance = 8
	invisableElectricPole9x9.maximum_wire_distance = 9
	invisableElectricPole9x10.maximum_wire_distance = 10
	invisableElectricPole10x10.maximum_wire_distance = 10
	invisableElectricPole12x12.maximum_wire_distance = 12

else
	invisableElectricPole1x1.maximum_wire_distance = 5
	invisableElectricPole2x2.maximum_wire_distance = 5
	invisableElectricPole3x3.maximum_wire_distance = 5
	invisableElectricPole4x4.maximum_wire_distance = 10
	invisableElectricPole5x5.maximum_wire_distance = 12
	invisableElectricPole6x6.maximum_wire_distance = 14
	invisableElectricPole7x7.maximum_wire_distance = 15
	invisableElectricPole8x8.maximum_wire_distance = 15
	invisableElectricPole9x9.maximum_wire_distance = 15
	invisableElectricPole9x10.maximum_wire_distance = 15
	invisableElectricPole10x10.maximum_wire_distance = 15
	invisableElectricPole12x12.maximum_wire_distance = 15
end

invisableElectricPole1x1.order = "z"
invisableElectricPole2x2.order = "z"
invisableElectricPole3x3.order = "z"
invisableElectricPole4x4.order = "z"
invisableElectricPole5x5.order = "z"
invisableElectricPole6x6.order = "z"
invisableElectricPole7x7.order = "z"
invisableElectricPole8x8.order = "z"
invisableElectricPole9x9.order = "z"
invisableElectricPole9x10.order = "z"
invisableElectricPole10x10.order = "z"
invisableElectricPole12x12.order = "z"

invisableElectricPole1x1.flags = flags
invisableElectricPole2x2.flags = flags
invisableElectricPole3x3.flags = flags
invisableElectricPole4x4.flags = flags
invisableElectricPole5x5.flags = flags
invisableElectricPole6x6.flags = flags
invisableElectricPole7x7.flags = flags
invisableElectricPole8x8.flags = flags
invisableElectricPole9x9.flags = flags
invisableElectricPole9x10.flags = flags
invisableElectricPole10x10.flags = flags
invisableElectricPole12x12.flags = flags

invisableElectricPole1x1.collision_box = collisionBox
invisableElectricPole2x2.collision_box = collisionBox
invisableElectricPole3x3.collision_box = collisionBox
invisableElectricPole4x4.collision_box = collisionBox
invisableElectricPole5x5.collision_box = collisionBox
invisableElectricPole6x6.collision_box = collisionBox
invisableElectricPole7x7.collision_box = collisionBox
invisableElectricPole8x8.collision_box = collisionBox
invisableElectricPole9x9.collision_box = collisionBox
invisableElectricPole9x10.collision_box = collisionBox
invisableElectricPole10x10.collision_box = collisionBox
invisableElectricPole12x12.collision_box = collisionBox

invisableElectricPole1x1.collision_mask = collisionMask
invisableElectricPole2x2.collision_mask = collisionMask
invisableElectricPole3x3.collision_mask = collisionMask
invisableElectricPole4x4.collision_mask = collisionMask
invisableElectricPole5x5.collision_mask = collisionMask
invisableElectricPole6x6.collision_mask = collisionMask
invisableElectricPole7x7.collision_mask = collisionMask
invisableElectricPole8x8.collision_mask = collisionMask
invisableElectricPole9x9.collision_mask = collisionMask
invisableElectricPole9x10.collision_mask = collisionMask
invisableElectricPole10x10.collision_mask = collisionMask
invisableElectricPole12x12.collision_mask = collisionMask

invisableElectricPole1x1.selection_box = nil
invisableElectricPole2x2.selection_box = nil
invisableElectricPole3x3.selection_box = nil
invisableElectricPole4x4.selection_box = nil
invisableElectricPole5x5.selection_box = nil
invisableElectricPole6x6.selection_box = nil
invisableElectricPole7x7.selection_box = nil
invisableElectricPole8x8.selection_box = nil
invisableElectricPole9x9.selection_box = nil
invisableElectricPole9x10.selection_box = nil
invisableElectricPole10x10.selection_box = nil
invisableElectricPole12x12.selection_box = nil

invisableElectricPole1x1.pictures = pictures
invisableElectricPole2x2.pictures = pictures
invisableElectricPole3x3.pictures = pictures
invisableElectricPole4x4.pictures = pictures
invisableElectricPole5x5.pictures = pictures
invisableElectricPole6x6.pictures = pictures
invisableElectricPole7x7.pictures = pictures
invisableElectricPole8x8.pictures = pictures
invisableElectricPole9x9.pictures = pictures
invisableElectricPole9x10.pictures = pictures
invisableElectricPole10x10.pictures = pictures
invisableElectricPole12x12.pictures = pictures

invisableElectricPole1x1.connection_points = connectionPoints
invisableElectricPole2x2.connection_points = connectionPoints
invisableElectricPole3x3.connection_points = connectionPoints
invisableElectricPole4x4.connection_points = connectionPoints
invisableElectricPole5x5.connection_points = connectionPoints
invisableElectricPole6x6.connection_points = connectionPoints
invisableElectricPole7x7.connection_points = connectionPoints
invisableElectricPole8x8.connection_points = connectionPoints
invisableElectricPole9x9.connection_points = connectionPoints
invisableElectricPole9x10.connection_points = connectionPoints
invisableElectricPole10x10.connection_points = connectionPoints
invisableElectricPole12x12.connection_points = connectionPoints

invisableElectricPole1x1.max_health = 2147483648
invisableElectricPole2x2.max_health = 2147483648
invisableElectricPole3x3.max_health = 2147483648
invisableElectricPole4x4.max_health = 2147483648
invisableElectricPole5x5.max_health = 2147483648
invisableElectricPole6x6.max_health = 2147483648
invisableElectricPole7x7.max_health = 2147483648
invisableElectricPole8x8.max_health = 2147483648
invisableElectricPole9x9.max_health = 2147483648
invisableElectricPole9x10.max_health = 2147483648
invisableElectricPole10x10.max_health = 2147483648
invisableElectricPole12x12.max_health = 2147483648

--[[invisableElectricPole1x1. = nil
invisableElectricPole2x2. = nil
invisableElectricPole3x3. = nil
invisableElectricPole4x4. = nil
invisableElectricPole5x5. = nil
invisableElectricPole6x6. = nil
invisableElectricPole7x7. = nil
invisableElectricPole8x8. = nil
invisableElectricPole9x9. = nil
invisableElectricPole9x10. = nil
invisableElectricPole10x10. = nil
invisableElectricPole12x12. = nil]]

data:extend ({	invisableElectricPole1x1, 
				invisableElectricPole2x2, 
				invisableElectricPole3x3, 
				invisableElectricPole4x4, 
				invisableElectricPole5x5, 
				invisableElectricPole6x6, 
				invisableElectricPole7x7, 
				invisableElectricPole8x8, 
				invisableElectricPole9x9, 
				invisableElectricPole9x10,
				invisableElectricPole10x10, 
				invisableElectricPole12x12
			})