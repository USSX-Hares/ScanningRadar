local utils = require('script.utils')
local core_util = require('__core__.lualib.util')

local NO_SPRITE = core_util.empty_sprite()


--- @type LuaEntityPrototype
local radar =
{
    icon = Resources.get_graphics_item(Resources.graphics_item_types.ItemIcon, Names.prototypes.radar),
    icon_size = 32,
    flags = { 'placeable-player', 'player-creation' },
    minable =
    {
        hardness = 0.2,
        mining_time = 0.5,
        result = 'scanning-radar',
    },
    max_health = 250,
    energy_per_sector = '100MJ',
    max_distance_of_sector_revealed = 0,
    max_distance_of_nearby_sector_revealed = 0,
    energy_per_nearby_scan = '100kJ',
    energy_usage = '10.1MW',
    radius_minimap_visualisation_color = { r = 0.059, g = 0.092, b = 0.235, a = 0.275 },
}
radar = utils.update_prototype(flib.copy_prototype(data.raw['radar']['radar'], Names.prototypes.radar), radar)


--- @type LuaEntityPrototype
local power_unit =
{
    type = 'radar',
    name = Names.prototypes.power_unit,
    icon = Resources.get_graphics_item(Resources.graphics_item_types.ItemIcon, Names.prototypes.power_unit),
    icon_size = 32,
    flags = { 'hidden', 'not-on-map', 'not-blueprintable', 'not-deconstructable', 'not-rotatable', 'no-copy-paste' },
    minable = nil,
    max_health = 1,
    corpse = nil,
    energy_per_sector = '1J',
    max_distance_of_sector_revealed = 0,
    max_distance_of_nearby_sector_revealed = 0,
    energy_per_nearby_scan = '1J',
    energy_source =
    {
        type = 'electric',
        usage_priority = 'secondary-input',
    },
    energy_usage = '2500.1kW',
    pictures = NO_SPRITE,
    collision_box = radar.collision_box,
    collision_mask = { },
}


--- @type LuaEntityPrototype
local dummy_connector =
{
    name = Names.prototypes.dummy_connector,
    icon = Resources.get_graphics_item(Resources.graphics_item_types.ItemIcon, Names.prototypes.connector),
    icon_size = 32,
    flags = { 'hidden', 'not-on-map', 'not-blueprintable', 'not-deconstructable', 'not-rotatable' },
    collision_mask = { },
    minable = nil,
    animations =
    {
        north = NO_SPRITE,
        east = NO_SPRITE,
        south = NO_SPRITE,
        west = NO_SPRITE,
    },
    circuit_wire_max_distance = 9,
}
dummy_connector = utils.update_prototype(flib.copy_prototype(data.raw['pump']['pump'], Names.prototypes.dummy_connector), dummy_connector)
dummy_connector.energy_source.type = 'void'
dummy_connector.minable = nil
dummy_connector.next_upgrade = nil


--- @type LuaEntityPrototype
local connector =
{
    icon = Resources.get_graphics_item(Resources.graphics_item_types.ItemIcon, Names.prototypes.connector),
    icon_size = 32,
    signal_to_color_mapping = { },
    selection_box = { {-0.5, -0.5}, {0.5, 0.5} },
    selection_priority = (radar.selection_priority or 50) + 10,
    collision_box = { { -0.15, -0.15 }, { 0.15, 0.15 } },
    collision_mask = { },
    always_on = true,
}
connector = utils.update_prototype(flib.copy_prototype(data.raw['lamp']['small-lamp'], Names.prototypes.connector), connector)
connector.energy_source.type = 'void'
connector.minable = nil
connector.next_upgrade = nil


data:extend({ radar, power_unit, dummy_connector, connector })
