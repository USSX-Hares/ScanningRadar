local base_name = 'ScanningRadar'
local base_id = 'scanning-radar'

----
--- @module Names
--- This module defines names and IDs for all entities (prototypes, settings, other refs, etc)
--- used within the Scanning Radars mod.
--- Changing values in this file is safe as long as appropriate changes are made to the following files:
---  * Migration scripts
---  * Locale files
---  * info.json (only for the mod identifier change)
---
--- @field base_name string Defines the mod name used for some internal variables. Should be nested from the original ScanningRadar mod.
--- @field mod_id string Defines the mod identifier (as it is named in Factorio mods directory). Should be changed if distributed by the other name.
--- @field settings table<string, string> Defines identifiers for the settings used within the mod.
--- @field prototypes table<string, string> Defines identifiers for the prototypes (entities, items, tech, etc.) used within the mod.
----
local Names =
{
    base_name = base_name,
    mod_id = base_name,
    
    settings =
    {
        default_radar_range = base_name .. '_radius',
        default_radar_speed = base_name .. '_speed',
        default_radar_direction = base_name .. '_direction',
        radar_requires_power = base_name .. '_power',
    },
    
    prototypes =
    {
        radar = base_id,
        connector = base_id .. '-connector',
        power_unit = base_id .. '-power-unit',
        tech = base_id .. '-tech',
        dummy_connector = base_id .. '-connector-dummy',
    }
}

return Names
