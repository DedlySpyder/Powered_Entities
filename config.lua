--This will change between manual and automatic mode
--true will force the player to make power pads to have entities be linked to the power grid
--false will be the old way where the entities are linked to the power grid on their own
manual_mode = settings.startup["Powered_Entities_manual_mode"].value

--This will make the powered entities only have enough wire reach to hit another like entity right next to it
--For example: an assembling machine will only have enough wire reach to hit an assembler right next to it (to each side)
minimum_wire_reach = settings.startup["Powered_Entities_minimum_wire_reach"].value

--The following lists are the entities that the mod supports
--You can change which entities act as certain power poles by adding or removing the entities from the lists

--DO NOT DELETE ANY LIST ENTIRELY
--If you want to remove all of the entities from a category then just empty the list so that only the curly brackets remain "{}"

entities1x1 = {	"small-lamp",
				"small-pump"}

entities2x2 = {	"accumulator",
				"laser-turret"}

entities3x3 = {	"assembling-machine-1", 
				"assembling-machine-2", 
				"assembling-machine-3",
				"radar",
				"electric-mining-drill",
				"electric-furnace",
				"lab",
				"solar-panel",
				"chemical-plant", 
				"beacon",
				"pumpjack",
				"centrifuge"}

entities4x4 = {"roboport"}

entities5x5 = {"oil-refinery"}

entities6x6 = {}

entities7x7 = {}

entities8x8 = {}

entities9x9 = {}

entities9x10 = {"rocket-silo"}

entities10x10 = {}

entities12x12 = {}

--Debug
debug_mode = false