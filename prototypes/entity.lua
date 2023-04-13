require ('__core__.lualib.circuit-connector-sprites')
local hit_effects = require ('__base__.prototypes.entity.hit-effects')
local sounds = require('__base__.prototypes.entity.sounds')
local Names = require('util.names')
local Resources = require('util.resources')

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
    type = 'radar',
    name = Names.radar,
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
    corpse = 'big-remnants',
    resistances =
    {
        { type = 'fire', percent = 70 },
        { type = 'impact', percent = 30 },
    },
    collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
    selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
    energy_per_sector = '100MJ',
    max_distance_of_sector_revealed = 0,
    max_distance_of_nearby_sector_revealed = 0,
    energy_per_nearby_scan = '100kJ',
    energy_source =
    {
        type = 'electric',
        usage_priority = 'secondary-input',
    },
    energy_usage = '10.1MW',
    integration_patch =
    {
        filename = '__base__/graphics/entity/radar/radar-integration.png',
        priority = 'low',
        width = 119,
        height = 108,
        apply_projection = false,
        direction_count = 1,
        repeat_count = 64,
        line_length = 1,
        shift = util.by_pixel(1.5, 4),
        hr_version =
        {
            filename = '__base__/graphics/entity/radar/hr-radar-integration.png',
            priority = 'low',
            width = 238,
            height = 216,
            apply_projection = false,
            direction_count = 1,
            repeat_count = 64,
            line_length = 1,
            shift = util.by_pixel(1.5, 4),
            scale = 0.5,
        },
    },
    pictures =
    {
        layers =
        {
            {
                filename = '__base__/graphics/entity/radar/radar.png',
                priority = 'low',
                width = 98,
                height = 128,
                apply_projection = false,
                direction_count = 64,
                line_length = 8,
                shift = util.by_pixel(1, -16),
                hr_version =
                {
                    filename = '__base__/graphics/entity/radar/hr-radar.png',
                    priority = 'low',
                    width = 196,
                    height = 254,
                    apply_projection = false,
                    direction_count = 64,
                    line_length = 8,
                    shift = util.by_pixel(1, -16),
                    scale = 0.5,
                },
            },
            {
                filename = '__base__/graphics/entity/radar/radar-shadow.png',
                priority = 'low',
                width = 172,
                height = 94,
                apply_projection = false,
                direction_count = 64,
                line_length = 8,
                shift = util.by_pixel(39,3),
                draw_as_shadow = true,
                hr_version =
                {
                    filename = '__base__/graphics/entity/radar/hr-radar-shadow.png',
                    priority = 'low',
                    width = 343,
                    height = 186,
                    apply_projection = false,
                    direction_count = 64,
                    line_length = 8,
                    shift = util.by_pixel(39.25,3),
                    draw_as_shadow = true,
                    scale = 0.5,
                },
            },
        },
    },
    vehicle_impact_sound = { filename = '__base__/sound/car-metal-impact.ogg', volume = 0.65 },
    working_sound =
    {
        sound = { { filename = '__base__/sound/radar.ogg', }, },
        apparent_volume = 2,
    },
    radius_minimap_visualisation_color = { r = 0.059, g = 0.092, b = 0.235, a = 0.275 },
}

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
    -- yes, this causes a graphical glitch where the entity images overlap but it's 
    -- better than having a blank box in the mouse over window
    animations =
    {
        north = NO_SPRITE,
        east = NO_SPRITE,
        south = NO_SPRITE,
        west = NO_SPRITE,
    },
    --circuit_wire_connection_points = circuit_connector_definitions['pump'].points,
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
    --circuit_connector_sprites = circuit_connector_definitions['pump'].sprites,
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
    type = 'lamp',
    name = Names.connector,
    icon = Resources.get_graphics_item(Resources.graphics_item_types.ItemIcon, Names.connector),
    icon_size = 32,
    flags = { 'player-creation', 'not-deconstructable', 'not-rotatable' },
    --order = 'a-a-b',
    minable = nil,
    energy_source =
    {
        type = 'void',
        usage_priority = 'secondary-input',
        emissions = 0,
    },
    max_health = 100,
    corpse = 'lamp-remnants',
    dying_explosion = 'lamp-explosion',
    collision_box = { {-0.15, -0.15}, {0.15, 0.15} },
    selection_box = { {-0.5, -0.5}, {0.5, 0.5} },
    damaged_trigger_effect = hit_effects.entity(),
    vehicle_impact_sound = sounds.generic_impact,
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,
    energy_usage_per_tick = '5KW',
    darkness_for_all_lamps_on = 0.5,
    darkness_for_all_lamps_off = 0.3,
    light = { intensity = 0.9, size = 40, color = {r=1.0, g=1.0, b=0.75} },
    light_when_colored = { intensity = 0, size = 6, color = {r=0, g=1.0, b=0.25} },
    glow_size = 6,
    glow_color_intensity = 1,
    glow_render_mode = 'multiplicative',
    picture_off =
    {
        layers =
        {
            {
                filename = '__base__/graphics/entity/small-lamp/lamp.png',
                priority = 'high',
                width = 42,
                height = 36,
                frame_count = 1,
                axially_symmetrical = false,
                direction_count = 1,
                shift = util.by_pixel(0,3),
                hr_version =
                {
                    filename = '__base__/graphics/entity/small-lamp/hr-lamp.png',
                    priority = 'high',
                    width = 83,
                    height = 70,
                    frame_count = 1,
                    axially_symmetrical = false,
                    direction_count = 1,
                    shift = util.by_pixel(0.25,3),
                    scale = 0.5
                }
            },
            {
                filename = '__base__/graphics/entity/small-lamp/lamp-shadow.png',
                priority = 'high',
                width = 38,
                height = 24,
                frame_count = 1,
                axially_symmetrical = false,
                direction_count = 1,
                shift = util.by_pixel(4,5),
                draw_as_shadow = true,
                hr_version =
                {
                    filename = '__base__/graphics/entity/small-lamp/hr-lamp-shadow.png',
                    priority = 'high',
                    width = 76,
                    height = 47,
                    frame_count = 1,
                    axially_symmetrical = false,
                    direction_count = 1,
                    shift = util.by_pixel(4, 4.75),
                    draw_as_shadow = true,
                    scale = 0.5
                }
            }
        }
    },
    picture_on =
    {
        filename = '__base__/graphics/entity/small-lamp/lamp-light.png',
        priority = 'high',
        width = 46,
        height = 40,
        frame_count = 1,
        axially_symmetrical = false,
        direction_count = 1,
        shift = util.by_pixel(0, -7),
        hr_version =
        {
            filename = '__base__/graphics/entity/small-lamp/hr-lamp-light.png',
            priority = 'high',
            width = 90,
            height = 78,
            frame_count = 1,
            axially_symmetrical = false,
            direction_count = 1,
            shift = util.by_pixel(0, -7),
            scale = 0.5
        }
    },
    signal_to_color_mapping = { },
    always_on = true,
    
    circuit_wire_connection_point = circuit_connector_definitions['lamp'].points,
    circuit_connector_sprites = circuit_connector_definitions['lamp'].sprites,
    circuit_wire_max_distance = default_circuit_wire_max_distance,
}

data:extend({ radar, power_unit, dummy_connector, connector })
