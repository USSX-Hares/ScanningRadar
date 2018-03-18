data:extend({
  {
    type = "item",
    name = "scanning-radar",
    icon = "__ScanningRadar__/graphics/item_icon_scanningradar.png",
    icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "defensive-structure",
    order = "z[radar]-a[radar]",
    place_result = "scanning-radar",
    stack_size = 10
  },
  {
    type = "item",
    name = "scanning-radar-connection",
    icon = "__core__/graphics/empty.png",
    icon_size = 1,
    flags = {"hidden"},
    stack_size = 1
  }
})
