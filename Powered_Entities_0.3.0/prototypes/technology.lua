data:extend ({

{
    type = "technology",
    name = "powered-entities",
    icon = "__Powered_Entities__/graphics/power_pad_tech.png",
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
        {"science-pack-1", 1},
        {"science-pack-2", 1}
      },
      time = 30
    },
    order = "c-e-a",
 }
 })