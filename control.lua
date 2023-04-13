local Names = require('util.names')

--- @param radar LuaEntity
--- @return RadarState
function InitializeState(radar)
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

do
	---- Init ----
	
	local function init_radars()
		--- @type RadarData[]
		global.ScanningRadars = { }
		-- Pick up any orphaned scanning radars
		for _, surface in pairs(game.surfaces) do
			--- @type LuaEntity[]
			radars = surface.find_entities_filtered { name=Names.radar }
			for _, radar in pairs(radars) do
				local connection = surface.find_entity(Names.connector, radar.position)
				if connection == nil then
					connection = surface.create_entity { name=Names.connector, position=radar.position, force=radar.force }
				end
				local dump = surface.find_entities_filtered { name=Names.power_dump, position=radar.position, force=radar.force }
				table.insert(global.ScanningRadars, { connection=connection, radar=radar, dump=dump, state=InitializeState(radar) })
			end
		end
	end
	
	local events = require('events')
	
	script.on_load(function()
		events.register_events(true)
	end)
	
	script.on_init(function()
		init_radars()
		events.register_events(true)
	end)
	
	script.on_configuration_changed(function(data)
		init_radars()
		events.register_events(true)
	end)
end
