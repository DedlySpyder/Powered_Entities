local invisableElectricPole1x1 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
local invisableElectricPole2x2 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
local invisableElectricPole3x3 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
local invisableElectricPole4x4 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
local invisableElectricPole5x5 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
local invisableElectricPole9x10 = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
local invisableElectricPoleCustom = util.table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])

local flags = {"placeable-player", "player-creation", "placeable-off-grid"}
local collisionBox = {{-0, -0}, {0, 0}}
local collisionMask = {"ghost-layer"}
local pictures = {
				  filename = "__Powered_Entities__/graphics/invisible_power_pole.png",
				  width = 0,
				  height = 0,
				  direction_count = 4,
				  shift = {1.4, -1.1}
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
	  },
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
	  },
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
	  },
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
invisableElectricPole1x1.maximum_wire_distance = 5
invisableElectricPole1x1.supply_area_distance = 1.5

invisableElectricPole2x2.name = "invisable-electric-pole-2x2"
invisableElectricPole2x2.maximum_wire_distance = 5
invisableElectricPole2x2.supply_area_distance = 2

invisableElectricPole3x3.name = "invisable-electric-pole-3x3"
invisableElectricPole3x3.maximum_wire_distance = 5
invisableElectricPole3x3.supply_area_distance = 2.5

invisableElectricPole4x4.name = "invisable-electric-pole-4x4"
invisableElectricPole4x4.maximum_wire_distance = 10
invisableElectricPole4x4.supply_area_distance = 3

invisableElectricPole5x5.name = "invisable-electric-pole-5x5"
invisableElectricPole5x5.maximum_wire_distance = 12
invisableElectricPole5x5.supply_area_distance = 3.5

invisableElectricPole9x10.name = "invisable-electric-pole-9x10"
invisableElectricPole9x10.maximum_wire_distance = 15
invisableElectricPole9x10.supply_area_distance = 5.5

invisableElectricPoleCustom.name = "invisable-electric-pole-custom"
invisableElectricPoleCustom.maximum_wire_distance = custom_power_pole_wire_distance
invisableElectricPoleCustom.supply_area_distance = custom_power_pole_power_radius

invisableElectricPole1x1.order = "z"
invisableElectricPole2x2.order = "z"
invisableElectricPole3x3.order = "z"
invisableElectricPole4x4.order = "z"
invisableElectricPole5x5.order = "z"
invisableElectricPole9x10.order = "z"
invisableElectricPoleCustom.order = "z"

invisableElectricPole1x1.flags = flags
invisableElectricPole2x2.flags = flags
invisableElectricPole3x3.flags = flags
invisableElectricPole4x4.flags = flags
invisableElectricPole5x5.flags = flags
invisableElectricPole9x10.flags = flags
invisableElectricPoleCustom.flags = flags

invisableElectricPole1x1.collision_box = collisionBox
invisableElectricPole2x2.collision_box = collisionBox
invisableElectricPole3x3.collision_box = collisionBox
invisableElectricPole4x4.collision_box = collisionBox
invisableElectricPole5x5.collision_box = collisionBox
invisableElectricPole9x10.collision_box = collisionBox
invisableElectricPoleCustom.collision_box = collisionBox

invisableElectricPole1x1.collision_mask = collisionMask
invisableElectricPole2x2.collision_mask = collisionMask
invisableElectricPole3x3.collision_mask = collisionMask
invisableElectricPole4x4.collision_mask = collisionMask
invisableElectricPole5x5.collision_mask = collisionMask
invisableElectricPole9x10.collision_mask = collisionMask
invisableElectricPoleCustom.collision_mask = collisionMask

invisableElectricPole1x1.selection_box = nil
invisableElectricPole2x2.selection_box = nil
invisableElectricPole3x3.selection_box = nil
invisableElectricPole4x4.selection_box = nil
invisableElectricPole5x5.selection_box = nil
invisableElectricPole9x10.selection_box = nil
invisableElectricPoleCustom.selection_box = nil

invisableElectricPole1x1.pictures = pictures
invisableElectricPole2x2.pictures = pictures
invisableElectricPole3x3.pictures = pictures
invisableElectricPole4x4.pictures = pictures
invisableElectricPole5x5.pictures = pictures
invisableElectricPole9x10.pictures = pictures
invisableElectricPoleCustom.pictures = pictures

invisableElectricPole1x1.connection_points = connectionPoints
invisableElectricPole2x2.connection_points = connectionPoints
invisableElectricPole3x3.connection_points = connectionPoints
invisableElectricPole4x4.connection_points = connectionPoints
invisableElectricPole5x5.connection_points = connectionPoints
invisableElectricPole9x10.connection_points = connectionPoints
invisableElectricPoleCustom.connection_points = connectionPoints

--[[invisableElectricPole1x1. = nil
invisableElectricPole2x2. = nil
invisableElectricPole3x3. = nil
invisableElectricPole4x4. = nil
invisableElectricPole5x5. = nil
invisableElectricPole9x10. = nil
invisableElectricPoleCustom. = nil]]

data:extend ({	invisableElectricPole1x1, 
				invisableElectricPole2x2, 
				invisableElectricPole3x3, 
				invisableElectricPole4x4, 
				invisableElectricPole5x5, 
				invisableElectricPole9x10, 
				invisableElectricPoleCustom
			})