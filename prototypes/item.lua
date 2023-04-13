local Names = require('util.names')
local Resources = require('util.resources')

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

local connector =
{
    type = 'item',
    name = Names.connector,
    icon = Resources.get_graphics_item(Resources.graphics_item_types.ItemIcon, Names.connector),
    icon_size = 32,
    flags = { 'hidden' },
    stack_size = 1
}

data:extend({ radar, power_unit, connector })
