require("config")
require("prototypes.entities.general_entities")

if manual_mode then
	require("prototypes.items")
	require("prototypes.entities.manual_mode_entities")
	require("prototypes.recipes")
	require("prototypes.technologies.manual_mode_tech")
end

if not manual_mode then
	require("prototypes.technologies.automatic_mode_tech")
end