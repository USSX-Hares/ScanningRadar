local radar =
{
    type = 'item',
    name = Names.radar,
    icon = Resources.get_graphics_item(Resources.graphics_item_types.ItemIcon, Names.radar),
    icon_size = 32,
    subgroup = 'defensive-structure',
    order = 'z[radar]-a[radar]',
    place_result = Names.radar,
    stack_size = 10,
    default_request_amount = 10
}

local power_unit =
{
    type = 'item',
    name = Names.power_unit,
    icon = Resources.get_graphics_item(Resources.graphics_item_types.ItemIcon, Names.power_unit),
    icon_size = 32,
    flags = { 'hidden' },
    stack_size = 1
}

local connector = flib.copy_prototype(data.raw["item"]["small-lamp"], Names.connector)
connector.flags = { 'hidden' }

data:extend({ radar, power_unit, connector })
