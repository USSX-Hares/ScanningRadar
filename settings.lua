data:extend({
  {
    type = "int-setting",
    name = "ScanningRadar_radius",
    setting_type = "runtime-global",
    minimum_value = 5,
    maximum_value = 400,
    default_value = 18,
    order = "1"
  },
  {
    type = "string-setting",
    name = "ScanningRadar_direction",
    setting_type = "runtime-global",
    default_value = "Counterclockwise",
	allowed_values = { "Counterclockwise", "Clockwise" },
    order = "2"
  }
})
