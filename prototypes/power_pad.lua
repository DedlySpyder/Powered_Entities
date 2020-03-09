data:extend ({
	{
		type = "recipe",
		name = "Powered_Entities_power_pad",
		enabled = false,
		ingredients =
		{
			{"electronic-circuit", 2},
			{"copper-cable", 2},
			{"iron-plate", 1}
		},
		result = "Powered_Entities_power_pad"
	},
	{
		type = "item",
		name = "Powered_Entities_power_pad",
		icon = "__Powered_Entities__/graphics/power_pad_icon.png",
		icon_size = 32,
		subgroup = "energy-pipe-distribution",
		order = "a[energy]-e[Powered_Entities_power_pad]",
		place_result = "Powered_Entities_power_pad",
		stack_size = 50
	},
	{
		type = "lamp",
		name = "Powered_Entities_power_pad",
		icon = "__Powered_Entities__/graphics/power_pad_icon.png",
		icon_size = 32,
		flags = {"placeable-neutral", "player-creation"},
		minable = {hardness = 0.2, mining_time = 0.5, result = "Powered_Entities_power_pad"},
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
	}
})
