local impl = require('script.core')
local utils = require('script.utils')
local init = require('script.init')

local UPDATE_INTERVAL = 3

--- @module events
local events = { }


----
--- Destroys the given entity unless it is another given entity.
---
--- @param target LuaEntity
--- @param skip_if LuaEntity
--- @param force ForceIdentification?
--- @param cause LuaEntity?
----
local function destroy_entity_unless_equal(target, skip_if, force, cause)
    if (target ~= skip_if) then
        if (cause ~= nil)
        then
            target.destructible = true
            target.die(force, cause)
        else
            target.destroy()
        end
    end
end

----
--- Deletes linked entities from the global tables, as well as the global table entry.
--- Entities being remove leave corpses if the owner died.
---
--- @param radar_index number The index of the radar in the global table.
--- @param event_entity LuaEntity|nil Optional. The entity that event is called upon.
--- @param force ForceIdentification? Optional. Used only when corpses should remain
--- @param cause LuaEntity? Optional. Used only when corpses should remain
----
local function delete_radar(radar_index, event_entity, force, cause)
    local radar_data = global.ScanningRadars[radar_index]
    
    for _, dump in pairs(radar_data.power_units) do
        destroy_entity_unless_equal(dump, event_entity)
    end
    
    destroy_entity_unless_equal(radar_data.radar, event_entity, force, cause)
    destroy_entity_unless_equal(radar_data.connector, event_entity, force, cause)
    
    table.remove(global.ScanningRadars, radar_index)
    
    -- unregister when the last is removed
    if #global.ScanningRadars == 0 then
        events.unregister_events()
    end
end

function events.OnEntityCreated(event)
    if event.created_entity.name == Names.radar then
        init.add_radar_to_index(event.created_entity)
        -- register to events after placing the first
        if #global.ScanningRadars == 1 then
            events.register_events()
        end
    end
end

----
--- Stepping from tick modulo, with stride
function events.OnTick(event)
    local offset = game.tick % UPDATE_INTERVAL
    for i=#global.ScanningRadars - offset, 1, -1 * UPDATE_INTERVAL do
        local group = global.ScanningRadars[i]
        impl.read_signals(group)
        impl.scan_next(group)
    end
end

----
--- This event is called when any radar entity is removed by either way.
---
--- @param event { entity: LuaEntity }
----
function events.OnEntityRemoved(event)
    local index = utils.find_radar_index(event.entity)
    if (index == 0) then return end
    delete_radar(index, event.entity, event.force, event.cause)
end

----
--- Registers the events for this mod.
--- This happens on start, load, and/or configuration change, as well as when the 1st radar is placed.
---
--- @param register_on_build boolean|nil Optional. If set, will register OnEntityCreated event too.
----
function events.register_events(register_on_build)
    if (register_on_build) then
        for _, event in pairs( { defines.events.on_built_entity, defines.events.on_robot_built_entity }) do
            script.on_event(event, events.OnEntityCreated, { { filter='name', name=Names.radar } })
        end
    end
    
    if (global.ScanningRadars and next(global.ScanningRadars)) then
        script.on_event(defines.events.on_tick, events.OnTick)
        local filter = { { filter='name', name=Names.radar } }
        for _, event in pairs({ defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died }) do
            script.on_event(event, events.OnEntityRemoved, filter)
        end
    end
end

----
--- Registers the events for this mod.
--- This happens on start, load, and/or configuration change, as well as when the 1st radar is placed.
---
--- @param unregister_on_build boolean|nil Optional. If set, will unregister OnEntityCreated event too.
----
function events.unregister_events(unregister_on_build)
    if (unregister_on_build) then
        script.on_event({ defines.events.on_built_entity, defines.events.on_robot_built_entity }, nil)
    end
    
    script.on_event(defines.events.on_tick, nil)
    script.on_event({ defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died }, nil)
end

return events
