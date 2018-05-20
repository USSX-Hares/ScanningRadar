function OnEntityCreated(event)
	if event.created_entity.name == "scanning-radar" then
		local connection = event.created_entity.surface.create_entity{name = "scanning-radar-connection", position = event.created_entity.position, force = event.created_entity.force}
		table.insert(global.ScanningRadars, {connection = connection, radar=event.created_entity, dump = {}, state = InitializeState(event.created_entity)})
		-- register to events after placing the first
		if #global.ScanningRadars == 1 then
			script.on_event(defines.events.on_tick, OnTick)
			script.on_event({defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined}, OnEntityMined)
			script.on_event({defines.events.on_entity_died}, OnEntityDied)
		end
	end
end

function OnEntityMined(event)
	local index = -1
	if event.entity.name == "scanning-radar-connection" then
		for i=#global.ScanningRadars, 1, -1 do
			if global.ScanningRadars[i].connection.unit_number == event.entity.unit_number then
				index = i
				--game.print("mined connection")
				break
			end
		end
	elseif event.entity.name == "scanning-radar" then
		for i=#global.ScanningRadars, 1, -1 do
			if global.ScanningRadars[i].radar.unit_number == event.entity.unit_number then
				index = i
				--game.print("mined radar")
				break
			end
		end
	elseif event.entity.name == "scanning-radar-powerdump" then
		for i=#global.ScanningRadars, 1, -1 do
			for j=1, #global.ScanningRadars[i].dump, 1 do
				if global.ScanningRadars[i].dump[j].unit_number == event.entity.unit_number then
					index = i
					--game.print("mined power")
					break
				end
			end
			if index ~= -1 then
				break
			end
		end
	end
	if index ~= -1 then
		for j=1, #global.ScanningRadars[index].dump, 1 do
			global.ScanningRadars[index].dump[j].destroy()
		end
		global.ScanningRadars[index].radar.destroy()
		table.remove(global.ScanningRadars, index)
		-- unregister when the last is removed
		if #global.ScanningRadars == 0 then
			script.on_event(defines.events.on_tick, nil)
			script.on_event({defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined}, nil)
			script.on_event({defines.events.on_entity_died}, nil)
		end
	end
end

function OnEntityDied(event)
	local index = -1
	if event.entity.name == "scanning-radar-connection" then
		for i=#global.ScanningRadars, 1, -1 do
			if global.ScanningRadars[i].connection.unit_number == event.entity.unit_number then
				index = i
				--game.print("killed connection")
				break
			end
		end
	elseif event.entity.name == "scanning-radar" then
		for i=#global.ScanningRadars, 1, -1 do
			if global.ScanningRadars[i].radar.unit_number == event.entity.unit_number then
				index = i
				--game.print("killed radar")
				break
			end
		end
	elseif event.entity.name == "scanning-radar-powerdump" then
		for i=#global.ScanningRadars, 1, -1 do
			for j=1, #global.ScanningRadars[i].dump, 1 do
				if global.ScanningRadars[i].dump[j].unit_number == event.entity.unit_number then
					index = i
					--game.print("killed power")
					break
				end
			end
			if index ~= -1 then
				break
			end
		end
	end
	if index ~= -1 then
		for j=1, #global.ScanningRadars[index].dump, 1 do
			global.ScanningRadars[index].dump[j].destroy()
		end
		global.ScanningRadars[index].radar.destroy()
		global.ScanningRadars[index].connection.destroy()
		table.remove(global.ScanningRadars, index)
		-- unregister when the last is removed
		if #global.ScanningRadars == 0 then
			script.on_event(defines.events.on_tick, nil)
			script.on_event({defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined}, nil)
			script.on_event({defines.events.on_entity_died}, nil)
		end
	end
end

-- Stepping from tick modulo, with stride, adapted from eradicator
function OnTick(event)
	local update_interval = 3
	local offset = game.tick % update_interval
	for i=#global.ScanningRadars - offset, 1, -1 * update_interval do
		read_signals(global.ScanningRadars[i])
		scan_next(global.ScanningRadars[i])
	end
end

function read_signals(radar)
	local entity = radar.connection
	local values = { r = 0,
	                 b = 0,
	                 e = 0,
	                 d = 0,
	                 n = 0,
	                 s = 0
	}
	-- read red signals
	local network = entity.get_circuit_network(defines.wire_type.red)
	if network then
		values = get_siganls(network, values)
	end
	-- sum with green signals
	local network = entity.get_circuit_network(defines.wire_type.green)
	if network then
		values = get_siganls(network, values)
	end
	-- apply signals
	-- set inside radius and push the outside radius out if needed
	if values.n < 1 then
		values.n = 1
	end
	if values.n > 499 then
		values.n = 499
	end
	radar.state.inner = values.n * 32
	if radar.state.radius < values.n * 32 or (values.r > 0 and values.r < values.n) then
		values.r = values.n + 1
	end
	-- set outside radius and max step size
	local tau = 6.2831853071796
	if values.r <= 0 and radar.state.radius ~= settings.global["ScanningRadar_radius"].value * 32 then
		values.r = settings.global["ScanningRadar_radius"].value
	end
	-- Ok, thats big enough.
	if values.r > 500 then
		values.r = 500
	end
	if values.r > 0 then
		radar.state.radius = values.r * 32
		radar.state.step = 1 / values.r
	end
	-- constrain angle
	if values.b ~= 0 or values.e ~= 0 then
		radar.state.constrained = true
		radar.state.oscillate = true
		radar.state.start = tau * values.b / 360 
		radar.state.stop = tau * values.e / 360
	-- otherwise clear constraint
	else
		radar.state.constrained = false
		radar.state.oscillate = false
		radar.state.start = 0
		radar.state.stop = 0
	end
	-- force direction even if constrained
	if values.d > 0 then 
		radar.state.direction = 1
		radar.state.oscillate = false
	elseif values.d < 0 then
		radar.state.direction = -1
		radar.state.oscillate = false
	elseif radar.state.constrained then
		radar.state.oscillate = true
	end
	-- set speed
	if values.s == 0 then
		values.s = settings.global["ScanningRadar_speed"].value
	end
	if values.s >= 1 and values.s <= 10 then
		radar.state.speed = values.s
	end
end

function get_siganls(network, values)
	if network then
		local signals = network.signals
		if signals then 
			for _, signal in pairs(signals) do
				if signal.signal.name then
					if signal.signal.name == "signal-R" or signal.signal.name == "signal-F" then
						values.r = values.r + signal.count
					elseif signal.signal.name == "signal-D" then
						values.d = values.d + signal.count
					elseif signal.signal.name == "signal-B" then
						values.b = values.b + signal.count
						values.b = values.b % 360
					elseif signal.signal.name == "signal-E" then
						values.e = values.e + signal.count
						values.e = values.e % 360
					elseif signal.signal.name == "signal-N" then
						values.n = values.n + signal.count
					elseif signal.signal.name == "signal-S" then
						values.s = values.s + signal.count
					end
				end
			end
		end
	end
	return values
end

function is_pump_enabled(pump)
	local control = pump.get_control_behavior()
	if control and control.valid then
		if control.connect_to_logistic_network then
			if control.logistic_condition then
				if not control.logistic_condition.fulfilled then
					return false
				end
			else
				return false
			end
		end
		if control.get_circuit_network(defines.wire_type.red, defines.circuit_connector_id.pump) or control.get_circuit_network(defines.wire_type.green, defines.circuit_connector_id.pump) then
			if control.disabled then
				return false
			end
		end
	end
	return true
end

function make_power_dump(radar)
	-- =9.824379*(PI()*$N$8^2-PI()*$M$8^2)*P9/5/1000
	local constant = .00617283937849
	local dump_size = 2.5
	local i = radar.state.inner / 32 - 1
	local o = radar.state.radius / 32
	local s = radar.state.speed
	local extra = (constant * (o * o - i * i) * s - 10) / dump_size
	if extra < 0 or not settings.global["ScanningRadar_power"].value then
		extra = 0
	end
	extra = extra + .5 - (extra + .5) % 1
	-- try not to stall the game too badly. Caps power usage at 10GW
	if extra > 4000 then
		extra = 4000
	end
	if extra > #radar.dump then
		--game.print( "need " .. extra - #radar.dump .. " more entities")
		for i=1, extra - #radar.dump, 1 do
			local sink = radar.radar.surface.create_entity{name = "scanning-radar-powerdump", position = radar.radar.position, force = radar.radar.force}
			table.insert(radar.dump, sink)
		end
	elseif extra < #radar.dump then
		--game.print( "need " .. #radar.dump - extra .. " fewer entities")
		for i=#radar.dump, extra + 1, -1 do
			radar.dump[i].destroy()
			table.remove(radar.dump, i)
		end
	end
end

function scan_next(radar)
	local entity = radar.radar
	local state = radar.state
	local enabled = is_pump_enabled(radar.connection)
	for i=1, #radar.dump, 1 do
		radar.dump[i].active = enabled
	end
	entity.active = enabled
	-- don't scan if the power is low
	-- check now so the dump still draws power
	if entity.energy < 160000 then
		enabled = false
	end
	if entity.is_connected_to_electric_network() and enabled then
		-- plot only when we've rotated far enough to pick up next chunk on outside circumference
		local fullstep = state.previous + (state.step - .00000001) * state.direction
		if (state.direction == -1 and state.angle <= fullstep) or (state.direction == 1 and state.angle >= fullstep) then
			local coa = math.cos(state.angle)
			local soa = math.sin(state.angle)
			local near = { x = state.cx + state.inner * coa,
			               y = state.cy + state.inner * soa}
			local far = { x = state.cx + state.radius * coa,
			              y = state.cy + state.radius * soa}
			if state.charting > 3 then
				radar.state.charting = radar.state.charting - 3
			else
				radar.state.charting = scan_line(entity.force, entity.surface, near.x, near.y, far.x, far.y)
			end
			if radar.state.charting < 3 then
				radar.state.previous = state.angle
				radar.state.charting = 0
			end
		end
		if radar.state.charting == 0 then
			-- move at speed
			local magnitude = 10
			magnitude = (magnitude + 1) - state.speed / 10 * magnitude
			magnitude = magnitude * magnitude
			local step = state.step / magnitude
			local new_angle = state.angle + step * state.direction
			-- is the angle constrained?
			if state.constrained then
				local a = state.start < state.stop
				local b = state.direction > 0
				local c = new_angle < state.start
				local d = new_angle > state.stop
				if b and d and (a or (not a and c)) then
					if state.oscillate then
						radar.state.direction = -1
						new_angle = state.stop
						radar.state.previous = new_angle + state.step
					else
						new_angle = state.start
						radar.state.previous = new_angle - state.step
					end
				elseif not b and c and (a or (not a and d)) then
					if state.oscillate then
						radar.state.direction = 1
						new_angle = state.start
						radar.state.previous = new_angle - state.step
					else
						new_angle = state.stop
						radar.state.previous = new_angle + state.step
					end
				end
			end
			-- wrap around at Tau and zero
			local tau = 6.2831853071796
			if new_angle >= tau then
				new_angle = new_angle - tau
				radar.state.previous = state.previous - tau
			elseif new_angle < 0 then
				new_angle = new_angle + tau
				radar.state.previous = state.previous + tau
			end
			-- save back new angle
			radar.state.angle = new_angle
		end
	end
	-- once every ten updates, refresh dump entities. Better UPS and more certain execution
	if state.counter >= 10 then
		make_power_dump(radar)
		radar.state.counter = 0
	else
		radar.state.counter = state.counter + 1
	end
end

function scan_line(force, surface, x0, y0, x1, y1)
	if math.abs(y1 - y0) < math.abs(x1 - x0) then
		if x0 > x1 then
			return plotLineLow(force, surface, x1, y1, x0, y0)
		else
			return plotLineLow(force, surface, x0, y0, x1, y1)
		end
	else
		if y0 > y1 then
			return plotLineHigh(force, surface, x1, y1, x0, y0)
		else
			return plotLineHigh(force, surface, x0, y0, x1, y1)
		end
	end
end

function plotLineLow(force, surface, x0,y0, x1,y1)
	local charting = 0
	local dx = x1 - x0
	local dy = y1 - y0
	local yi = 1
	if dy < 0 then
		yi = -1
		dy = -dy
	end
	local D = 2*dy - dx
	local y = y0
	local xlow = 1
	local ylow = 1
	local xhigh = -1
	local yhigh = -1
	for x = x0, x1, 1 do
		if not (x >= xlow and x < xhigh and y >= ylow and y < yhigh) then
			charting = charting + (not force.is_chunk_charted(surface, {x/32,y/32}) and 1 or 0)
			force.chart(surface, {{x,y}, {x,y}})
			xlow = math.floor(x / 32) * 32
			ylow = math.floor(y / 32) * 32
			xhigh = xlow + 32
			yhigh = ylow + 32
		end
		if D > 0 then
			y = y + yi
			D = D - 2*dx
		end
		D = D + 2*dy
	end
	return charting
end

function plotLineHigh(force, surface, x0,y0, x1,y1)
	local charting = 0
	local dx = x1 - x0
	local dy = y1 - y0
	local xi = 1
	if dx < 0 then
		xi = -1
		dx = -dx
	end
	local D = 2 * dx - dy
	local x = x0
	local xlow = 1
	local ylow = 1
	local xhigh = -1
	local yhigh = -1
	for y=y0, y1, 1 do
		if not (x >= xlow and x < xhigh and y >= ylow and y < yhigh) then
			charting = charting + (not force.is_chunk_charted(surface, {x/32,y/32}) and 1 or 0)
			force.chart(surface, {{x,y}, {x,y}})
			xlow = math.floor(x / 32) * 32
			ylow = math.floor(y / 32) * 32
			xhigh = xlow + 32
			yhigh = ylow + 32
		end
		if D > 0 then
			x = x + xi
			D = D - 2 * dy
		end
		D = D + 2 * dx
	end
	return charting
end

function InitializeState(radar)
	-- build state of new radar with defaults
	local state = {
	    cx = math.floor(radar.position.x / 32) * 32 + 16,
	    cy = math.floor(radar.position.y / 32) * 32 + 16,
	    radius = settings.global["ScanningRadar_radius"].value * 32,
	    inner = 1 * 32,
	    angle = 0,
	    previous = 0,
	    step = 1 / settings.global["ScanningRadar_radius"].value,
	    direction = -1,
	    constrained = false,
	    oscillate = false,
	    start = 0,
	    stop = 0,
	    speed = settings.global["ScanningRadar_speed"].value,
	    counter = 0,
	    charting = 0
	}
	if settings.global["ScanningRadar_direction"].value == "Clockwise" then
		state.direction = 1
		state.previous = -state.step
	else
		state.previous = state.step
	end
	return state
end

do---- Init ----
local function init_radars()
	global.ScanningRadars = {}
	-- Pick up any orphaned scanning radars
	for _, surface in pairs(game.surfaces) do
		radars = surface.find_entities_filtered {
			name = "scanning-radar",
		}
		for _, radar in pairs(radars) do
			local connection = surface.find_entity("scanning-radar-connection", radar.position)
			if connection == nil then
				connection = surface.create_entity{name = "scanning-radar-connection", position = radar.position, force = radar.force}
			end
			local dump = surface.find_entities_filtered{name="scanning-radar-powerdump", position = radar.position, force = radar.force}
			table.insert(global.ScanningRadars, {connection = connection, radar=radar, dump=dump, state=InitializeState(radar)})
		end
	end
end

local function init_events()
	script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, OnEntityCreated)
	if global.ScanningRadars and next(global.ScanningRadars) then
		script.on_event(defines.events.on_tick, OnTick)
		script.on_event({defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined}, OnEntityMined)
		script.on_event({defines.events.on_entity_died}, OnEntityDied)
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
