Names = require('script.descriptors.names')

local init = require('script.init')
local events = require('script.events')

do
	---- Init ----
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
