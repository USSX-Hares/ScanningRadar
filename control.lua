do
	---- Init ----
	
	
	local init = require('init')
	local events = require('events')
	
	script.on_load(function()
		events.register_events(true)
	end)
	
	script.on_init(function()
		init.init_radars()
		events.register_events(true)
	end)
	
	script.on_configuration_changed(function(data)
		init.init_radars()
		events.register_events(true)
	end)
end
