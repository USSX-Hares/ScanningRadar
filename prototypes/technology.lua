data:extend({
  {
    type = "technology",
    name = "scanning-radar-tech",
    icon_size = 128,
    icon = "__ScanningRadar__/graphics/technology_icon_scanningradar.png",
    prerequisites = {"electric-engine","advanced-electronics-2"},
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "scanning-radar"
      }
    },
    unit =
    {
      count = 50,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1},
        {"science-pack-3", 1},
        {"military-science-pack", 1}
      },
      time = 30
    },
    order = "i-h"
  }
})
