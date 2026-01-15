extends VBoxContainer

@export var ramp_properties : RampProperties
@export var atmo_properties : AtmosfericProperties
@export var second_ramp_ui : Control

@export_category("Properties")
@export var beta_angle_label : Label
@export var pressure_ramp_label : Label
@export var density_ramp_label : Label
@export var temperature_ramp_label : Label
@export var stag_temp_ramp_label : Label
@export var stag_pressure_ramp_label : Label
@export var sound_velocity_label : Label
@export var flow_velocity_label : Label
@export var mach_number_label : Label
 

@export var theta_spin_box : SpinBox

func _update_properties():
	beta_angle_label.text = "Beta Angle: %.2f °" % [ramp_properties.beta]
	pressure_ramp_label.text = "Pressure: %.2f Pa" % [ramp_properties.get_pressure_ramp(atmo_properties.pressure_pa)]
	density_ramp_label.text = "Density: %.4f kg/m3" % [ramp_properties.get_density_ramp(atmo_properties.density_kg_m3)]
	temperature_ramp_label.text = "Temperature: %.2f K" % [ramp_properties.get_temperature_ramp(atmo_properties.temp_kelvin)]
	stag_temp_ramp_label.text = "Stag. Temp.: %.2f K" % [ramp_properties.get_stagnation_temperature_normal()]
	stag_pressure_ramp_label.text = "Stag. Press.: %.2f Pa" % [ramp_properties.get_stagnation_pressure_normal()]
	sound_velocity_label.text = "Sound Velocity: %.2f m/s" % [ramp_properties.get_sound_velocity()]
	flow_velocity_label.text = "Flow Velocity: %.2f m/s" % [ramp_properties.get_flow_velocity()]
	mach_number_label.text = "Mach Number: %f" % [ramp_properties.mach_number]



func _on_spin_box_value_changed(value: float) -> void:
	ramp_properties.theta = value
	ramp_properties.beta = ramp_properties.calculate_weak_beta(atmo_properties.mach_number, value, atmo_properties.gamma)
	ramp_properties._set_m_normal_1(atmo_properties.mach_number)
	ramp_properties._set_m_normal_2()
	ramp_properties._set_ramp_mach_number()
	second_ramp_ui.theta_spin_box.min_value = ramp_properties.theta + 0.1
	_update_properties()
	
	
