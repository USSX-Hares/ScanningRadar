require ('__core__.lualib.circuit-connector-sprites')
local hit_effects = require ('__base__.prototypes.entity.hit-effects')
local sounds = require('__base__.prototypes.entity.sounds')
local Names = require('util.names')
local Resources = require('util.resources')

flib = require('__flib__.data-util')

----
--- Updates the given prototype with a patch.
--- Updates are in-place
---
--- @param base LuaEntityPrototype Base prototype to be patched
--- @param patch table Patch to apply
--- @return LuaEntityPrototype The updated instance
----
local function update_prototype(base, patch)
    for k, v in pairs(patch)
    do base[k] = v
    end
    
    return base
end

--- @type Sprite
local NO_SPRITE =
{
    filename = '__core__/graphics/empty.png',
    priority = 'low',
    width = 1,
    height = 1,
    direction_count = 1,
}


--- @type LuaEntityPrototype
local radar =
{
    icon = Resources.get_graphics_item(Resources.graphics_item_types.ItemIcon, Names.radar),
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
radar = update_prototype(flib.copy_prototype(data.raw['radar']['radar'], Names.radar), radar)


--- @type LuaEntityPrototype
local power_unit =
{
    type = 'radar',
    name = Names.power_unit,
    icon = Resources.get_graphics_item(Resources.graphics_item_types.ItemIcon, Names.power_unit),
    icon_size = 32,
    flags = { 'hidden', 'not-on-map', 'not-blueprintable', 'not-deconstructable', 'not-rotatable', 'no-copy-paste' },
    order = 'a-a-a',
    minable =
    {
        hardness = 0.2,
        mining_time = 0.5,
        result = nil,
    },
    max_health = 1,
    corpse = 'big-remnants',
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
    pictures = NO_SPRITE
}


--- @type LuaEntityPrototype
local dummy_connector =
{
    type = 'pump',
    name = Names.dummy_connector,
    icon = Resources.get_graphics_item(Resources.graphics_item_types.ItemIcon, Names.connector),
    icon_size = 32,
    flags = { 'hidden', 'not-on-map', 'not-blueprintable', 'not-deconstructable', 'not-rotatable' },
    minable = nil,
    fluid_box =
    {
        base_area = 1,
        pipe_covers = pipecoverspictures(),
        pipe_connections = { },
    },
    energy_source =
    {
        type = 'void',
        usage_priority = 'secondary-input',
        emissions = 0,
    },
    energy_usage = '1W',
    pumping_speed = 0.01,
    animations =
    {
        north = NO_SPRITE,
        east = NO_SPRITE,
        south = NO_SPRITE,
        west = NO_SPRITE,
    },
    circuit_wire_connection_points =
    {
        {
            shadow = { green = { -1.28125, -0.40625 },  red = { -1.34375, -0.234375 } },
            wire   = { green = { -1.45313, -0.046875 }, red = { -1.375, -0.21875 } },
        },
        {
            shadow = { green = { -1.28125, -0.40625 },  red = { -1.34375, -0.234375 } },
            wire   = { green = { -1.45313, -0.046875 }, red = { -1.375, -0.21875 } },
        },
        {
            shadow = { green = { -1.28125, -0.40625 },  red = { -1.34375, -0.234375 } },
            wire   = { green = { -1.45313, -0.046875 }, red = { -1.375, -0.21875 } },
        },
        {
            shadow = { green = { -1.28125, -0.40625 },  red = { -1.34375, -0.234375 } },
            wire   = { green = { -1.45313, -0.046875 }, red = { -1.375, -0.21875 } },
        },
    },
    circuit_connector_sprites =
    {
        {
            blue_led_light_offset = { -1.48438, -0.25 },
            connector_main =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04a-base-sequence.png',
                height = 50,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.390625 },
                width = 52,
                x = 0,
                y = 150,
            },
            led_blue =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04e-blue-LED-on-sequence.png',
                height = 60,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 60,
                x = 0,
                y = 180,
            },
            led_blue_off =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04f-blue-LED-off-sequence.png',
                height = 44,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 46,
                x = 0,
                y = 132,
            },
            led_green =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04h-green-LED-sequence.png',
                height = 46,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 48,
                x = 0,
                y = 138,
            },
            led_light = { intensity = 0.8, size = 0.9 },
            led_red =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04i-red-LED-sequence.png',
                height = 46,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 48,
                x = 0,
                y = 138,
            },
            red_green_led_light_offset = { -1.46875, -0.359375 },
            wire_pins =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04c-wire-sequence.png',
                height = 58,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 62,
                x = 0,
                y = 174,
            },
            wire_pins_shadow =
            {
                draw_as_shadow = true,
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04d-wire-shadow-sequence.png',
                height = 54,
                priority = 'low',
                scale = 0.5,
                shift = { -1.125, -0.296875 },
                width = 70,
                x = 0,
                y = 162,
            },
        },
        {
            blue_led_light_offset = { -1.48438, -0.25 },
            connector_main =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04a-base-sequence.png',
                height = 50,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.390625 },
                width = 52,
                x = 0,
                y = 150,
            },
            led_blue =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04e-blue-LED-on-sequence.png',
                height = 60,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 60,
                x = 0,
                y = 180,
            },
            led_blue_off =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04f-blue-LED-off-sequence.png',
                height = 44,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 46,
                x = 0,
                y = 132,
            },
            led_green =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04h-green-LED-sequence.png',
                height = 46,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 48,
                x = 0,
                y = 138,
            },
            led_light = {intensity = 0.8,
            size = 0.9},
            led_red =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04i-red-LED-sequence.png',
                height = 46,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 48,
                x = 0,
                y = 138,
            },
            red_green_led_light_offset = { -1.46875, -0.359375 },
            wire_pins =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04c-wire-sequence.png',
                height = 58,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 62,
                x = 0,
                y = 174,
            },
            wire_pins_shadow =
            {
                draw_as_shadow = true,
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04d-wire-shadow-sequence.png',
                height = 54,
                priority = 'low',
                scale = 0.5,
                shift = { -1.125, -0.296875 },
                width = 70,
                x = 0,
                y = 162,
            },
        },
        {
            blue_led_light_offset = { -1.48438, -0.25 },
            connector_main =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04a-base-sequence.png',
                height = 50,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.390625 },
                width = 52,
                x = 0,
                y = 150,
            },
            led_blue =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04e-blue-LED-on-sequence.png',
                height = 60,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 60,
                x = 0,
                y = 180,
            },
            led_blue_off =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04f-blue-LED-off-sequence.png',
                height = 44,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 46,
                x = 0,
                y = 132,
            },
            led_green =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04h-green-LED-sequence.png',
                height = 46,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 48,
                x = 0,
                y = 138,
            },
            led_light = {intensity = 0.8,
            size = 0.9},
            led_red =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04i-red-LED-sequence.png',
                height = 46,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 48,
                x = 0,
                y = 138,
            },
            red_green_led_light_offset = { -1.46875, -0.359375 },
            wire_pins =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04c-wire-sequence.png',
                height = 58,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 62,
                x = 0,
                y = 174,
            },
            wire_pins_shadow =
            {
                draw_as_shadow = true,
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04d-wire-shadow-sequence.png',
                height = 54,
                priority = 'low',
                scale = 0.5,
                shift = { -1.125, -0.296875 },
                width = 70,
                x = 0,
                y = 162,
            },
        },
        {
            blue_led_light_offset = { -1.48438, -0.25 },
            connector_main =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04a-base-sequence.png',
                height = 50,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.390625 },
                width = 52,
                x = 0,
                y = 150,
            },
            led_blue =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04e-blue-LED-on-sequence.png',
                height = 60,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 60,
                x = 0,
                y = 180,
            },
            led_blue_off =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04f-blue-LED-off-sequence.png',
                height = 44,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 46,
                x = 0,
                y = 132,
            },
            led_green =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04h-green-LED-sequence.png',
                height = 46,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 48,
                x = 0,
                y = 138,
            },
            led_light = { intensity = 0.8, size = 0.9 },
            led_red =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04i-red-LED-sequence.png',
                height = 46,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 48,
                x = 0,
                y = 138,
            },
            red_green_led_light_offset = { -1.46875, -0.359375 },
            wire_pins =
            {
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04c-wire-sequence.png',
                height = 58,
                priority = 'low',
                scale = 0.5,
                shift = { -1.28125, -0.421875 },
                width = 62,
                x = 0,
                y = 174,
            },
            wire_pins_shadow =
            {
                draw_as_shadow = true,
                filename = '__base__/graphics/entity/circuit-connector/hr-ccm-universal-04d-wire-shadow-sequence.png',
                height = 54,
                priority = 'low',
                scale = 0.5,
                shift = { -1.125, -0.296875 },
                width = 70,
                x = 0,
                y = 162,
            },
        },
    },
    circuit_wire_max_distance = 9,
}


--- @type LuaEntityPrototype
local connector =
{
    icon = Resources.get_graphics_item(Resources.graphics_item_types.ItemIcon, Names.connector),
    icon_size = 32,
    signal_to_color_mapping = { },
    always_on = true,
}
connector = update_prototype(flib.copy_prototype(data.raw['lamp']['small-lamp'], Names.connector), connector)
connector.energy_source.type = 'void'
connector.minable = nil
connector.next_upgrade = nil


data:extend({ radar, power_unit, dummy_connector, connector })
