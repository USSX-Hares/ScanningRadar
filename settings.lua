local Names = require('script.descriptors.names')

local default_radar_range = 
{
    type = 'int-setting',
    name = Names.settings.default_radar_range,
    setting_type = 'runtime-global',
    minimum_value = 16,
    maximum_value = 1000,
    default_value = 576,
    order = '1',
}

local default_radar_speed =
{
    type = 'int-setting',
    name = Names.settings.default_radar_speed,
    setting_type = 'runtime-global',
    minimum_value = 0,
    maximum_value = 10,
    default_value = 5,
    order = '2',
}

local default_radar_direction =
{
    type = 'string-setting',
    name = Names.settings.default_radar_direction,
    setting_type = 'runtime-global',
    default_value = 'Counterclockwise',
    allowed_values = { 'Counterclockwise', 'Clockwise' },
    order = '3',
}

local radar_requires_power =
{
    type = 'bool-setting',
    name = Names.settings.radar_requires_power,
    setting_type = 'runtime-global',
    default_value = true,
    order = '4',
}

data:extend({ default_radar_range, default_radar_speed, default_radar_direction, radar_requires_power })
