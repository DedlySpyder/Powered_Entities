data:extend({
	-- Startup settings
	{
		name = "Powered_Entities_00_manual_mode",
		type = "bool-setting",
		setting_type = "startup",
		default_value = true,
		order = "010"
	},
	{
		name = "Powered_Entities_01_minimum_wire_reach",
		type = "bool-setting",
		setting_type = "startup",
		default_value = false,
		order = "020"
	},
	{
		name = "Powered_Entities_90_debug_mode",
		type = "bool-setting",
		setting_type = "startup",
		default_value = false,
		order = "900"
	},
	{
		name = "Powered_Entities_91_trace_mode",
		type = "bool-setting",
		setting_type = "startup",
		default_value = false,
		order = "910"
	},
	{
		name = "Powered_Entities_99_debug_type",
		type = "string-setting",
		setting_type = "startup",
		default_value = "console",
		allowed_values = {"console", "file"},
		order = "990"
	},
	
	-- Runtime settings
	{
		name = "Powered_Entities_00_enable_inserter",
		type = "bool-setting",
		setting_type = "runtime-global",
		default_value = false,
		order = "010"
	},
	{
		name = "Powered_Entities_05_enable_solar",
		type = "bool-setting",
		setting_type = "runtime-global",
		default_value = true,
		order = "020"
	},
	{
		name = "Powered_Entities_10_enable_accumulator",
		type = "bool-setting",
		setting_type = "runtime-global",
		default_value = true,
		order = "030"
	},
	{
		name = "Powered_Entities_15_enable_producers",
		type = "bool-setting",
		setting_type = "runtime-global",
		default_value = false,
		order = "040"
	},
	{
		name = "Powered_Entities_entity_name_exclusion_list",
		type = "string-setting",
		setting_type = "runtime-global",
		default_value = "",
		allow_blank = true,
		order = "700"
	},
	{
		name = "Powered_Entities_report_localized_items",
		type = "bool-setting",
		setting_type = "runtime-global",
		default_value = true,
		order = "800"
	},
	{
		name = "Powered_Entities_80_recalculate_show",
		type = "bool-setting",
		setting_type = "runtime-global",
		default_value = true,
		order = "900"
	},
	{
		name = "Powered_Entities_90_recalculate_batch_size",
		type = "int-setting",
		setting_type = "runtime-global",
		default_value = 5,
		order = "910"
	},
	{
		name = "Powered_Entities_skip_recalculate_on_mod_changes",
		type = "bool-setting",
		setting_type = "runtime-global",
		default_value = false,
		order = "990"
	}
})
