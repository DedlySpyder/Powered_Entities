data:extend ({

{
    type = "technology",
    name = "powered-entities",
    icon = "__Powered_Entities__/graphics/power_pad_tech.png",
	icon_size = 64,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "power-pad"
      }
    },
    prerequisites = {"electronics"},
    unit =
    {
      count = 30,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1}
      },
      time = 30
    },
    order = "c-e-a",
 }
 })