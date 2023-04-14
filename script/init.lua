local utils = require('script.utils')

--- @module Init
local init = { }

local GHOST = 'entity-ghost'

----
--- Creates a new `RadarState` table for the given radar.
---
--- @param radar LuaEntity
--- @return RadarState
----
function init.init_state(radar)
    -- build state of new radar with defaults
    --- @type RadarState
    local state =
    {
        cx = radar.position.x,
        cy = radar.position.y,
        radius = settings.global["ScanningRadar_radius"].value,
        inner = 0,
        angle = 0,
        previous = 0,
        step = 1 / (settings.global["ScanningRadar_radius"].value / 32),
        direction = -1,
        constrained = false,
        oscillate = false,
        start = 0,
        stop = 0,
        speed = settings.global["ScanningRadar_speed"].value,
        counter = 0,
        uncharted = { },
        enabled = 1
    }
    
    if settings.global["ScanningRadar_direction"].value == "Clockwise" then
        state.direction = 1
        state.previous = -state.step
    else
        state.previous = state.step
    end
    if state.speed == 0 then
        state.enabled = false
    end
    
    return state
end

----
--- Updates the existing or just created entity flags.
--- Helper entities are set to be indestructible and non-minable.
---
--- @param entity LuaEntity
----
function init.update_entity_flags(entity)
    if (entity.name ~= Names.connector)
    then entity.operable = false
    end
    
    entity.minable = false
    entity.destructible = false
end

----
--- Creates a connector for a given radar.
---
--- @param radar LuaEntity
--- @return LuaEntity
----
function init.create_connector(radar)
    --- @type LuaEntity
    local connector = radar.surface.create_entity
    {
        name = Names.connector,
        position = utils.get_radar_connector_position(radar.position, radar.direction),
        force = radar.force,
    }
    
    init.update_entity_flags(connector)
    
    --- @type LuaLampControlBehavior?
    local ctl = connector.get_or_create_control_behavior()
    ctl.circuit_condition =
    {
        condition =
        {
            first_signal = { type='virtual', name='signal-anything' },
            comparator = '≠',
            constant = 0,
        }
    }
    
    return connector
end

----
--- Creates a power unit near the given radar.
---
--- @param radar LuaEntity
--- @return LuaEntity
----
function init.create_power_unit(radar)
    --- @type LuaEntity
    local power_unit = radar.surface.create_entity
    {
        name = Names.power_unit,
        position = radar.position,
        force = radar.force,
    }
    
    init.update_entity_flags(power_unit)
    
    return power_unit
end

----
--- Finds the entities of the given prototype ID at the given position.
--- Optionally searches *and revives* ghosts.
--- Same as `find_entity_at_position`, but returns a potentially-empty table of `LuaEntity`s.
---
--- @param prototype_id string Prototype name to be found.
--- @param surface LuaSurface The `LuaSurface` object on which the entity is searched for.
--- @param position MapPosition The exact position for item to be searched.
--- @param ghosts_allowed boolean? Optional, disabled by default.
--- @return LuaEntity[]
----
function init.find_entities_at_position(prototype_id, surface, position, ghosts_allowed)
    --- @type LuaEntity[]
    local data = { }
    
    --- @type LuaEntity[]
    local entities = surface.find_entities_filtered { name=prototype_id, position=position }
    for _, entity in pairs(entities)
    do
        if (entity.valid)
        then
            init.update_entity_flags(entity)
            table.insert(data, entity)
        end
    end
    
    if (ghosts_allowed)
    then
        --- @type LuaEntity[]
        local ghosts = surface.find_entities_filtered { name=GHOST, position=position, ghost_name=prototype_id }
        for _, ghost in pairs(ghosts)
        do
            if (ghost.valid)
            then
                --- @type LuaEntity
                local entity
                _, entity = ghost.revive()
                init.update_entity_flags(entity)
                table.insert(data, entity)
            end
        end
    end
    
    return data
end

----
--- Finds the entity of the given prototype ID at the given position.
--- Optionally searches *and revives* ghosts.
--- Same as `find_entities_at_position`, but returns either a single `LuaEntity` or `nil`.
---
--- @param prototype_id string Prototype name to be found.
--- @param surface LuaSurface The `LuaSurface` object on which the entity is searched for.
--- @param position MapPosition The exact position for item to be searched.
--- @param ghosts_allowed boolean? Optional, disabled by default.
--- @return LuaEntity?
----
function init.find_entity_at_position(prototype_id, surface, position, ghosts_allowed)
    --- @type LuaEntity?
    local entity
    
    if (ghosts_allowed)
    then
        --- @type LuaEntity
        local ghosts = surface.find_entities_filtered { name=GHOST, position=position, ghost_name=prototype_id }
        local ghost = ghosts and next(ghosts) and ghosts[next(ghosts)]
        if (ghost and ghost.valid and ghost.name == prototype_id)
        then
            _, entity = ghost.revive()
            init.update_entity_flags(entity)
            return entity
        end
    end
    
    entity = surface.find_entity(prototype_id, position)
    if (entity and entity.valid)
    then
        init.update_entity_flags(entity)
        return entity
    end
    
    return nil
end


----
--- @param radar LuaEntity
--- @return LuaEntity
----
function init.get_or_create_connector(radar)
    return init.find_entity_at_position(Names.connector, radar.surface, utils.get_radar_connector_position(radar.position, radar.direction), true)
            or init.create_connector(radar)
end

----
--- Adds the given radar entity to the global data.
--- Optionally creates connector, power units, state.
--- All parameters except for `radar` are optional.
---
--- @param radar LuaEntity
--- @param connector LuaEntity?
--- @param power_units LuaEntity[]?
--- @param state RadarState?
----
function init.add_radar_to_index(radar, connector, power_units, state)
    assert(radar ~= nil, "Radar should not be 'nil'")
    
    --- @type RadarData
    local data =
    {
        radar = radar,
        connector = connector or init.get_or_create_connector(radar),
        power_units = power_units or init.find_entities_at_position(Names.power_unit, radar.surface, radar.position, false),
        state = state or init.init_state(radar)
    }
    
    table.insert(global.ScanningRadars, data)
end

----
--- Reinitializes the global variable `ScanningRadars`.
--- Called on init, on configuration change, or on migration.
----
function init.init_radars()
    log("Reinitializing radars...")
    
    --- @type RadarData[]
    global.ScanningRadars = { }
    -- Pick up any orphaned scanning radars
    for _, surface in pairs(game.surfaces) do
        --- @type LuaEntity[]
        radars = surface.find_entities_filtered { name=Names.radar }
        for _, radar in pairs(radars) do
            log(string.format(" * Reinitializing radar #%i", radar.unit_number))
            init.add_radar_to_index(radar, connector, power_units)
        end
    end
    
    log("Reinitializing radars complete")
end

return init
