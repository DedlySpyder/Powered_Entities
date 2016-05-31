data:extend ({

{
	type = "lamp",
    name = "power-pad",
    icon = "__Powered_Entities__/graphics/power_pad_icon.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "power-pad"},
    max_health = 55,
	order = "z",
    corpse = "small-remnants",
    collision_box = {{-.01, -0.01}, {0.01, 0.01}},
	collision_mask = {"floor-layer"},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input"
    },
    energy_usage_per_tick = "2KW",
    light = {intensity = 0.75, size = 20},
    picture_off =
    {
      filename = "__Powered_Entities__/graphics/power_pad_off.png",
      priority = "very-low",
      width = 32,
      height = 32,
      frame_count = 1,
      axially_symmetrical = false,
      direction_count = 1,
      shift = {0, 0},
    },
    picture_on =
    {
      filename = "__Powered_Entities__/graphics/power_pad_on.png",
      priority = "very-low",
      width = 7,
      height = 7,
      frame_count = 1,
      axially_symmetrical = false,
      direction_count = 1,
      shift = {0, -0.25},
    },

    circuit_wire_connection_point =
    {
      shadow =
      {
        red = {0, -0.2},
        green = {0, -0.2},
      },
      wire =
      {
        red = {0, -0.2},
        green = {0, -0.2},
      }
    },

    circuit_wire_max_distance = 7.5
},
{
	type = "electric-pole",
	name = "power-pad-pole",
	icon = "__base__/graphics/icons/small-electric-pole.png",
	flags = {"placeable-player", "player-creation", "placeable-off-grid"},
	max_health = 1,
	order = "z",
	collision_box = {{-0, -0}, {0, 0}},
	collision_mask = {"ghost-layer"},
	--selection_box = {{-0, -0}, {0, 0}},
	--drawing_box = {{-0, -0}, {0, 0}},
	maximum_wire_distance = 7.5,
	supply_area_distance = 0.4,
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