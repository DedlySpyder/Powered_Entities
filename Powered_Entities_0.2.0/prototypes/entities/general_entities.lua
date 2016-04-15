data:extend ({

{
	type = "electric-pole",
	name = "small-invisable-electric-pole",
	icon = "__base__/graphics/icons/small-electric-pole.png",
	flags = {"placeable-player", "player-creation", "placeable-off-grid"},
	max_health = 1,
	order = "z",
	collision_box = {{-0, -0}, {0, 0}},
	collision_mask = {"ghost-layer"},
	--selection_box = {{-0, -0}, {0, 0}},
	--drawing_box = {{-0, -0}, {0, 0}},
	maximum_wire_distance = 7.5,
	supply_area_distance = 2.5,
	vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 },
	pictures =
	{
	  filename = "__Powered_Entities__/graphics/invisible_power_pole.png",
	  --priority = "extra-high",
	  width = 0,
	  height = 0,
	  direction_count = 4,
	  shift = {1.4, -1.1}
	},
	connection_points =
	{
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
	},
	radius_visualisation_picture =
	{
	  filename = "__base__/graphics/entity/small-electric-pole/electric-pole-radius-visualization.png",
	  width = 12,
	  height = 12,
	  priority = "extra-high-no-scale"
	}
},
{
	type = "electric-pole",
    name = "medium-invisable-electric-pole",
    icon = "__base__/graphics/icons/medium-electric-pole.png",
    flags = {"placeable-player", "player-creation", "placeable-off-grid"},
    max_health = 1,
	order = "z",
    collision_box = {{-0, -0}, {0, 0}},
	collision_mask = {"ghost-layer"},
    --selection_box = {{-0, -0}, {0, 0}},
    --drawing_box = {{-0, -0}, {0, 0}},
    maximum_wire_distance = 9,
    supply_area_distance = 3.5,
    vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 },
    pictures =
    {
      filename = "__Powered_Entities__/graphics/invisible_power_pole.png",
      --priority = "extra-high",
      width = 0,
      height = 0,
      direction_count = 4,
      shift = {1.4, -1.1}
    },
    connection_points =
	{
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
	},
    radius_visualisation_picture =
    {
      filename = "__base__/graphics/entity/small-electric-pole/electric-pole-radius-visualization.png",
      width = 12,
      height = 12,
      priority = "extra-high-no-scale"
    }
},
{
	type = "electric-pole",
    name = "large-invisable-electric-pole",
    icon = "__base__/graphics/icons/substation.png",
    flags = {"placeable-player", "player-creation", "placeable-off-grid"},
    max_health = 1,
	order = "z",
    collision_box = {{-0, -0}, {0, 0}},
	collision_mask = {"ghost-layer"},
    --selection_box = {{-0, -0}, {0, 0}},
    --drawing_box = {{-0, -0}, {0, 0}},
    maximum_wire_distance = 14,
    supply_area_distance = 7,
    vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 },
    pictures =
    {
      filename = "__Powered_Entities__/graphics/invisible_power_pole.png",
      --priority = "extra-high",
      width = 0,
      height = 0,
      direction_count = 4,
      shift = {1.4, -1.1}
    },
    connection_points =
	{
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
	},
    radius_visualisation_picture =
    {
      filename = "__base__/graphics/entity/small-electric-pole/electric-pole-radius-visualization.png",
      width = 12,
      height = 12,
      priority = "extra-high-no-scale"
    }
}
})