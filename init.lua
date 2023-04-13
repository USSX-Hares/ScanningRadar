local Names = require('util.names')
local getters = require('impl.getters')

--- @module Init
local init = { }

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
		connector = connector or radar.surface.create_entity { name=Names.connector, position=getters.get_radar_connector_position(radar.position, radar.direction), force=radar.force },
		power_units = power_units or { },
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
			
			local connector = surface.find_entity(Names.connector, getters.get_radar_connector_position(radar.position, radar.direction))
			local power_units = surface.find_entities_filtered { name=Names.power_unit, position=radar.position, force=radar.force }
			init.add_radar_to_index(radar, connector, power_units)
		end
	end
	
	log("Reinitializing radars complete")
end

return init
