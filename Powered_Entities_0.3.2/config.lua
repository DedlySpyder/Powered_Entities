--This will change between manual and automatic mode
--true will force the player to make power pads to have entities be linked to the power grid
--false will be the old way where the entities are linked to the power grid on their own
manual_mode = true


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
				"pumpjack"}

entities4x4 = {"roboport"}

entities5x5 = {"oil-refinery"}

entities9x10 = {"rocket-silo"}

--This list is highly configurable
--The other two variables here set the wire reach distance and the power radius of the entities in this list
entitiesCustom = {}
custom_power_pole_wire_distance = 1
custom_power_pole_power_radius = 5

--Debug
debug_mode = true