Names = require('util.names')

--- @module Getters
getters = { }

----
--- Calculates and returns radar connection position, for a given coordinates and orientation.
--- 
--- @param position MapPosition
--- @param direction string
--- @return MapPosition
----
function getters.get_radar_connector_position(position, direction )
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
function getters.find_radar_index(radar_entity)
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

return getters
