require "defines"

--This will change between the old version and the new version
--true will force the player to make power pads to have entities be linked to the power grid
--false will be the old way where the entities are linked to the power grid on their own
manual_mode = true


--The following lists are the entities that the mod supports
--You can change which entities act as certain power poles by adding or removing the entities from the lists

--DO NOT DELETE ANY LIST ENTIRELY
--If you want to remove all of the entities from a category then just empty the list so that only the curly brackets remain "{}"

--These entities will have the connection range/power radius of a small power pole
smallEntities = {"small-lamp", 
					"assembling-machine-1", 
					"assembling-machine-2", 
					"basic-mining-drill", 
					"basic-accumulator", 
					"electric-furnace",
					"lab", 
					"small-pump", 
					"solar-panel"}

--These entities will have the connection range/power radius of a medium power pole		
mediumEntities = {"assembling-machine-3", 
					"radar", 
					"chemical-plant", 
					"basic-beacon", 
					"laser-turret", 
					"pumpjack"}

--These entities will have the connection range/power radius of a substation
largeEntities = {"roboport", 
					"oil-refinery", 
					"rocket-silo"}



--Debug
debug_mode = false