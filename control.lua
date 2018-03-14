function OnEntityCreated(event)
	if event.created_entity.name == "scanning-radar" then
		InitializeSettings()
		table.insert(global.ScanningRadars, {entity = event.created_entity, state = InitializeState(event.created_entity)})
		-- register to events after placing the first scanning radar
		if #global.ScanningRadars == 1 then
			script.on_event(defines.events.on_tick, OnTick)
			script.on_event({defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died}, OnEntityRemoved)
		end
	end
end

function OnEntityRemoved(event)
	if event.entity.name == "scanning-radar" then
		for i=#global.ScanningRadars, 1, -1 do
			if global.ScanningRadars[i].entity.unit_number == event.entity.unit_number then
				table.remove(global.ScanningRadars, i)
			end
		end
		-- unregister when last radar is removed
		if #global.ScanningRadars == 0 then
			script.on_event(defines.events.on_tick, nil)
			script.on_event({defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died}, nil)
		end
	end
end

-- stepping from tick modulo with stride by eradicator
function OnTick(event)
	local update_interval = global.update
	local offset = game.tick % update_interval
	for i=#global.ScanningRadars - offset, 1, -1 * update_interval do
		scan_next(global.ScanningRadars[i])
	end
end

function scan_next(radar)
	local entity = radar.entity
	local radius = radar.state.r
	local direction = global.direction
	if entity.is_connected_to_electric_network() and entity.energy > 20000 then
		local chunk = {x = 0, y = 0}
		if radar.state.x >= 0 then
			if radar.state.q == 0 then
				chunk.x = radar.state.cx + radar.state.x
				chunk.y = radar.state.cy - (radar.state.y * direction) 
			elseif radar.state.q == 1 then
				chunk.x = radar.state.cx - radar.state.y
				chunk.y = radar.state.cy - (radar.state.x * direction)
			elseif radar.state.q == 2 then
				chunk.x = radar.state.cx - radar.state.x
				chunk.y = radar.state.cy + (radar.state.y * direction)
			elseif radar.state.q == 3 then
				chunk.x = radar.state.cx + radar.state.y
				chunk.y = radar.state.cy + (radar.state.x * direction)
			end
			scan_line(entity.force, entity.surface, radar.state.cx, radar.state.cy, chunk.x, chunk.y)
			local moved = false
			-- D(x,y,r) = x^2 + y^2 - r^2
			if radar.state.d < 0 then
				if (2 * radar.state.d + radar.state.x - .25) <= 0 then
					radar.state.y = radar.state.y + .5
					--D(x,y+.5,r)-D(x,y,r) := y+.25
					radar.state.d = radar.state.d + radar.state.y + .25
					moved = true
				end
			elseif radar.state.d > 0 then
				if (2 * radar.state.d - radar.state.y - .25) >= 0 then
					radar.state.x = radar.state.x - .5
					--D(x-.5,y,r)-D(x,y,r) := -x+.25
					radar.state.d = radar.state.d - radar.state.x + .25
					moved = true
				end
			end
			if not moved then
				radar.state.x = radar.state.x - .5
				radar.state.y = radar.state.y + .5
				--D(x-.5,y+.5,r)-D(x,y,r) := y-x+.5
				radar.state.d = radar.state.d + radar.state.y - radar.state.x + .5
			end
		else
			radar.state.x = radius
			radar.state.y = 0
			-- D(x-.5,y+.5,r)|x=r and y = 0 := .5 - r
			radar.state.d = .5 - radius
			radar.state.q = (radar.state.q + 1) % 4
		end
	end
end

function scan_line(force, surface, x0, y0, x1, y1)
	if math.abs(y1 - y0) < math.abs(x1 - x0) then
		if x0 > x1 then
			plotLineLow(force, surface, x1, y1, x0, y0)
		else
			plotLineLow(force, surface, x0, y0, x1, y1)
		end
	else
		if y0 > y1 then
			plotLineHigh(force, surface, x1, y1, x0, y0)
		else
			plotLineHigh(force, surface, x0, y0, x1, y1)
		end
	end
end

function plotLineLow(force, surface, x0,y0, x1,y1)
	local dx = x1 - x0
	local dy = y1 - y0
	local yi = 1
	if dy < 0 then
		yi = -1
		dy = -dy
	end
	local D = 2*dy - dx
	local y = y0
	for x = x0, x1, 1 do
		force.chart(surface, {{x*32,y*32}, {(x+1)*32-1,(y+1)*32-1}} )
		if D > 0 then
			y = y + yi
			D = D - 2*dx
		end
		D = D + 2*dy
	end
end

function plotLineHigh(force, surface, x0,y0, x1,y1)
	local dx = x1 - x0
	local dy = y1 - y0
	local xi = 1
	if dx < 0 then
		xi = -1
		dx = -dx
	end
	local D = 2 * dx - dy
	local x = x0

	for y=y0, y1, 1 do
		force.chart(surface, {{x*32,y*32}, {(x+1)*32-1,(y+1)*32-1}} )
		if D > 0 then
			x = x + xi
			D = D - 2 * dy
		end
		D = D + 2 * dx
	end
end

function InitializeSettings()
		global.radius = settings.global["ScanningRadar_radius"].value
		global.direction = 1
		if settings.global["ScanningRadar_direction"].value == "Clockwise" then
			global.direction = -1
		end
		global.update = 400 / global.radius
		if global.update < 2 then
			global.update = 2
		elseif global.update > 20 then
			global.update = 20
		end
end

function InitializeState(radar)
	return {
		cx = math.floor(radar.position.x / 32) + .5,
		cy = math.floor(radar.position.y / 32),
		x = global.radius,
		y = 0,
		d = .5 - global.radius,
		q = 0,
		r = global.radius
	}
end

do---- Init ----
local function init_radars()
	global.ScanningRadars = {}
	-- Pick up any orphaned scanning radars
	for _, surface in pairs(game.surfaces) do
		radars = surface.find_entities_filtered {
			name = "scanning-radar",
		}
		if #radars then
			InitializeSettings()
		end
		for _, radar in pairs(radars) do
			table.insert(global.ScanningRadars, {entity = radar, state = InitializeState(radar)})
		end
	end
end

local function init_events()
	script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, OnEntityCreated)
	if global.ScanningRadars and next(global.ScanningRadars) then
		script.on_event(defines.events.on_tick, OnTick)
		script.on_event({defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died}, OnEntityRemoved)
	end
end

script.on_load(function()
	init_events()
end)

script.on_init(function()
	init_radars()
	init_events()
end)

script.on_configuration_changed(function(data)
	init_radars()
	init_events()
end)

end
