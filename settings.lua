data:extend({
  {
    type = "int-setting",
    name = "ScanningRadar_radius",
    setting_type = "runtime-global",
    minimum_value = 2,
    maximum_value = 25,
    default_value = 18,
    order = "1"
  },
  {
    type = "int-setting",
    name = "ScanningRadar_speed",
    setting_type = "runtime-global",
    minimum_value = 1,
    maximum_value = 10,
    default_value = 5,
    order = "2"
  },
  {
    type = "string-setting",
    name = "ScanningRadar_direction",
    setting_type = "runtime-global",
    default_value = "Counterclockwise",
	allowed_values = { "Counterclockwise", "Clockwise" },
    order = "3"
  }
})
