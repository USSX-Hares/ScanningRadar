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
    if radar_entity.name == Names.prototypes.connector then
        for i=#global.ScanningRadars, 1, -1 do
            if global.ScanningRadars[i].connector.unit_number == radar_entity.unit_number then
                return i
            end
        end
    elseif radar_entity.name == Names.prototypes.radar then
        for i=#global.ScanningRadars, 1, -1 do
            if global.ScanningRadars[i].radar.unit_number == radar_entity.unit_number then
                return i
            end
        end
    elseif radar_entity.name == Names.prototypes.power_unit then
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

----
--- Converts the given entity its string representation.
--- Uses custom parsers for string and tables.
--- 
--- @param x any
--- @return string
function utils.repr(x)
    if (type(x) == 'table')
    then return utils.table2str(x)
    elseif (type(x) == 'string')
    then return "'" .. x .. "'"
    else return tostring(x)
    end
end

----
--- Converts the given table to string in format:
--- { key="value", key2="value2, key3={ subkey="data" } }
---
--- @param table table
--- @return string
function utils.table2str(table)
    assert(type(table) == 'table', string.format("%q only works with tables, got %q", 'utils.table2str', type(table)))
    
    local result = '{'
    local next = ' '
    
    for k, v in pairs(table)
    do
        result = result .. next .. tostring(k) .. '=' .. utils.repr(v)
        next = ', '
    end
    
    result = result .. ' }'
    return result
end

return utils
