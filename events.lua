local Names = require('util.names')
local impl = require('impl')

local UPDATE_INTERVAL = 3

--- @module events
local events = { }

----
--- Finds the radar global index for the entity that caused en event.
--- Returns an index in the global table.
--- 
--- @param radar_entity LuaEntity
--- @return number
----
local function find_radar_index(radar_entity)
	if radar_entity.name == Names.connector then
		for i=#global.ScanningRadars, 1, -1 do
			if global.ScanningRadars[i].connection.unit_number == radar_entity.unit_number then
				return i
			end
		end
	elseif radar_entity.name == Names.radar then
		for i=#global.ScanningRadars, 1, -1 do
			if global.ScanningRadars[i].radar.unit_number == radar_entity.unit_number then
				return i
			end
		end
	elseif radar_entity.name == Names.power_dump then
		for i=#global.ScanningRadars, 1, -1 do
			for _, dump in pairs(global.ScanningRadars[i].dump) do
				if dump.unit_number == radar_entity.unit_number then
					return i
				end
			end
		end
	end
	
	return -1
end

----
--- Destroys the given entity unless it is another given entity.
--- 
--- @param target LuaEntity
--- @param skip_if LuaEntity
----
local function destroy_entity_unless_equal(target, skip_if)
	if (target ~= skip_if) then
		target.destroy()
	end
end

----
--- Deletes linked entities from the global tables, as well as the global table entry.
--- Does
--- @param radar_index number The index of the radar in the global table.
--- @param event_entity LuaEntity|nil Optional. The entity that event is called upon.
----
local function delete_radar(radar_index, event_entity)
	local radar_data = global.ScanningRadars[radar_index]
	
	for _, dump in pairs(radar_data.dump) do
		destroy_entity_unless_equal(dump, event_entity)
	end
	
	destroy_entity_unless_equal(radar_data.radar, event_entity)
	destroy_entity_unless_equal(radar_data.connection, event_entity)
	
	table.remove(global.ScanningRadars, radar_index)
	
	-- unregister when the last is removed
	if #global.ScanningRadars == 0 then
		events.unregister_events()
	end
end

function events.OnEntityCreated(event)
	if event.created_entity.name == Names.radar then
		local connection = event.created_entity.surface.create_entity { name=Names.connector, position=event.created_entity.position, force=event.created_entity.force }
		table.insert(global.ScanningRadars, {connection = connection, radar=event.created_entity, dump = {}, state = InitializeState(event.created_entity)})
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
	local index = find_radar_index(event.entity)
	if (index == 0) then return end
	delete_radar(index, event.entity)
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
		local filter = { { filter='name', name=Names.radar }, { filter='name', name=Names.connector }, { filter='name', name=Names.power_dump } }
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