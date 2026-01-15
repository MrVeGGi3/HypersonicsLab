class_name ThirdRamp
extends VBoxContainer

@export var first_ramp : RampProperties
@export var previous_ramp : RampProperties
@export var ramp_properties : RampProperties
@export var atmo_properties : AtmosfericProperties

@export_category("Properties")
@export var total_theta_label : Label
@export var beta_angle_label : Label
@export var pressure_ramp_label : Label
@export var density_ramp_label : Label
@export var temperature_ramp_label : Label
@export var stag_temp_ramp_label : Label
@export var stag_pressure_ramp_label : Label
@export var sound_velocity_label : Label
@export var flow_velocity_label : Label
@export var mach_number_label : Label
 

func _update_properties():
	total_theta_label.text ="Total Theta: %.2f" % [ramp_properties.theta]
	beta_angle_label.text = "Beta Angle: %f °" % [ramp_properties.beta]
	pressure_ramp_label.text = "Pressure: %.2f Pa" % [ramp_properties.get_pressure_ramp(atmo_properties.pressure_pa)]
	density_ramp_label.text = "Density: %.4f kg/m3" % [ramp_properties.get_density_ramp(atmo_properties.density_kg_m3)]
	temperature_ramp_label.text = "Temperature: %.2f K" % [ramp_properties.get_temperature_ramp(atmo_properties.temp_kelvin)]
	stag_temp_ramp_label.text = "Stag. Temp.: %.2f K" % [ramp_properties.get_stagnation_temperature_normal()]
	stag_pressure_ramp_label.text = "Stag. Press.: %.2f Pa" % [ramp_properties.get_stagnation_pressure_normal()]
	sound_velocity_label.text = "Sound Velocity: %.2f m/s" % [ramp_properties.get_sound_velocity()]
	flow_velocity_label.text = "Flow Velocity: %.2f m/s" % [ramp_properties.get_flow_velocity()]
	mach_number_label.text = "Mach Number: %f" % [ramp_properties.mach_number]



func update_theta_value():
	ramp_properties.theta = first_ramp.theta + previous_ramp.theta 
	ramp_properties.beta = ramp_properties.calculate_weak_beta(previous_ramp.mach_number, ramp_properties.theta, atmo_properties.gamma)
	ramp_properties._set_m_normal_1(atmo_properties.mach_number)
	ramp_properties._set_m_normal_2()
	ramp_properties._set_ramp_mach_number()
	_update_properties()
	
	
