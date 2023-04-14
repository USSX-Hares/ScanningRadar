--- @module Utils
utils = { }


----
--- Updates the given prototype with a patch.
--- Updates are in-place
---
--- @param base LuaEntityPrototype Base prototype to be patched
--- @param patch table Patch to apply
--- @return LuaEntityPrototype The updated instance
----
function utils.update_prototype(base, patch)
    for k, v in pairs(patch)
    do base[k] = v
    end
    
    return base
end

----
--- Calculates and returns radar connection position, for a given coordinates and orientation.
---
--- @param position MapPosition
--- @param direction string
--- @return MapPosition
----
function utils.get_radar_connector_position(position, direction )
    local dx, dy
    
    if (direction == defines.direction.north)
    then dx = -1; dy = 1
    elseif (direction == defines.direction.east)
    then dx = -1; dy = -1
    elseif (direction == defines.direction.south)
    then dx = 1; dy = -1
    elseif (direction == defines.direction.west)
    then dx = 1; dy = 1
    else error(string.format("Unsupported entity direction: %q", direction))
    end
    
    return { x = position.x + dx, y = position.y + dy }
end

----
--- Finds the radar global index for the entity that caused en event.
--- Returns an index in the global table.
---
--- @param radar_entity LuaEntity
--- @return number
----
function utils.find_radar_index(radar_entity)
    if radar_entity.name == Names.connector then
        for i=#global.ScanningRadars, 1, -1 do
            if global.ScanningRadars[i].connector.unit_number == radar_entity.unit_number then
                return i
            end
        end
    elseif radar_entity.name == Names.radar then
        for i=#global.ScanningRadars, 1, -1 do
            if global.ScanningRadars[i].radar.unit_number == radar_entity.unit_number then
                return i
            end
        end
    elseif radar_entity.name == Names.power_unit then
        for i=#global.ScanningRadars, 1, -1 do
            for _, dump in pairs(global.ScanningRadars[i].power_units) do
                if dump.unit_number == radar_entity.unit_number then
                    return i
                end
            end
        end
    end
    
    return -1
end

return utils
