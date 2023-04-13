local table_is_initialized = global.ScanningRadars ~= nil and next(global.ScanningRadars) ~= nil

if (not table_is_initialized)
then
    log("Global table is not initialized, migration not required.")    
    return
end

local init = require('script.init')
local getters = require('script.utils')

init.init_radars()

log("Starting migration: v0.4.0")

local has_any = false
for _, s in pairs(game.surfaces)
do
    --- @type LuaEntity[]
    local dummies = s.find_entities_filtered { name=Names.dummy_connector }
    for _, dummy in pairs(dummies)
    do
        local radar = s.find_entity(Names.radar, dummy.position)
        local id = radar ~= nil and getters.find_radar_index(radar)
        if (id ~= nil and id >= 0)
        then
            local radar_data = global.ScanningRadars[id]
            
            for _, connection in pairs(dummy.circuit_connection_definitions)
            do radar_data.connector.connect_neighbour(connection)
            end
            
            --- @type LuaGenericOnOffControlBehavior?
            local dummy_control = dummy.get_control_behavior()
            if (dummy_control)
            then
                --- @type LuaLampControlBehavior?
                local connector_control = radar_data.connector.get_or_create_control_behavior()
                connector_control.circuit_condition = dummy_control.circuit_condition
                connector_control.logistic_condition = dummy_control.logistic_condition
                connect_to_logistic_network = dummy_control.connect_to_logistic_network
            end
            
            has_any = true
            log(string.format(" * Dummy entity %i: Migration successful.", dummy.unit_number))
        else log(string.format(" * Dummy entity %i: Can't find nearby radar.", dummy.unit_number))
        end
        
        dummy.destroy()
    end
end 

if (has_any)
then game.print("Mod 'Scanning Radar' performed an update from previous version.")
end

log(string.format("Migration complete. Replacements made: %s", has_any))
