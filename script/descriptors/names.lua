local name = 'ScanningRadar'

--- @module Names
local Names =
{
    mod_name = name,
    
    settings =
    {
        default_radar_range = name .. '_radius',
        default_radar_speed = name .. '_speed',
        default_radar_direction = name .. '_direction',
        radar_requires_power = name .. '_power',
    },
    
    radar = 'scanning-radar',
    connector = 'scanning-radar-connector',
    power_unit = 'scanning-radar-power-unit',
    tech = 'scanning-radar-tech',
    dummy_connector = 'scanning-radar-connector-dummy',
}

return Names
