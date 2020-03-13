Config = {}

Config.MANUAL_MODE = settings.startup["Powered_Entities_00_manual_mode"].value
Config.MINIMUM_WIRE_REACH = settings.startup["Powered_Entities_01_minimum_wire_reach"].value

Config.DEBUG_MODE = settings.startup["Powered_Entities_90_debug_mode"].value
Config.TRACE_MODE = settings.startup["Powered_Entities_91_trace_mode"].value
Config.DEBUG_TYPE = settings.startup["Powered_Entities_99_debug_type"].value

-- Doesn't exist during the data stage
if settings.global then
	function Config.refresh()
		Config.SHOW_RECALCULATE_NAME = "Powered_Entities_80_recalculate_show"
		
		Config.ENABLE_INSERTER = settings.global["Powered_Entities_00_enable_inserter"].value
		Config.ENABLE_SOLAR = settings.global["Powered_Entities_05_enable_solar"].value
		Config.ENABLE_ACCUMULATOR = settings.global["Powered_Entities_10_enable_accumulator"].value
		Config.ENABLE_PRODUCER = settings.global["Powered_Entities_15_enable_producers"].value
		Config.SHOW_RECALCULATE = settings.global[Config.SHOW_RECALCULATE_NAME].value
		Config.RECALCULATE_BATCH_SIZE = settings.global["Powered_Entities_90_recalculate_batch_size"].value
	end
	
	Config.refresh()
end

Config.POWER_PAD_NAME = "Powered_Entities_power_pad"
Config.INVISIBLE_POLE_BASE_NAME = "Powered_Entities_invisible-electric-pole-"
Config.INVISIBLE_POLE_BASE_NAME_ESCAPED = "Powered%_Entities%_invisible%-electric%-pole%-" -- For use in string.find()

Config.TECHNOLOGY_NAME = "Powered_Entities_main_tech"

Config.BLACKLISTED_ENTITY_TYPES = {
	"arrow",
	"artillery-flare",
	"artillery-projectile",
	"artillery-wagon",
	"beam",
	"car",
	"cargo-wagon",
	"character",
	"character-corpse",
	"cliff",
	"combat-robot",
	"construction-robot",
	"corpse",
	"deconstructible-tile-proxy",
	"decorative",
	"electric-pole",
	"entity-ghost",
	"explosion",
	"fire",
	"fish",
	"flame-thrower-explosion",
	"fluid-wagon",
	"flying-text",
	"highlight-box",
	"item-entity",
	"item-request-proxy",
	"leaf-particle",
	"locomotive",
	"logistic-robot",
	"particle",
	"particle-source",
	"projectile",
	"rail-remnants",
	"resource",
	"rocket-silo-rocket",
	"rocket-silo-rocket-shadow",
	"simple-entity",
	"smoke",
	"smoke-with-trigger",
	"speech-bubble",
	"sticker",
	"stream",
	"tile-ghost",
	"tree",
	"unit"
}
