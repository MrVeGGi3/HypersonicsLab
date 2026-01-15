class_name LabResults
extends Control

@export_category("Atmosphere Properties")
@export var atmo_height : Label
@export var mach_number : Label
@export var temperature : Label
@export var pressure : Label
@export var density : Label
@export var stag_temp : Label
@export var stag_press : Label
@export var flow_velocity : Label


@export_category("Ramp 1")
@export var theta_1 : Label
@export var beta_1 : Label
@export var ramp_1_mach_number : Label
@export var ramp_1_temperature : Label
@export var ramp_1_pressure : Label
@export var ramp_1_density : Label
@export var ramp_1_stag_temp : Label
@export var ramp_1_stag_press : Label
@export var ramp_1_flow_velocity : Label

@export_category("Ramp 2")
@export var theta_2 : Label
@export var beta_2 : Label
@export var ramp_2_mach_number : Label
@export var ramp_2_temperature : Label
@export var ramp_2_pressure : Label
@export var ramp_2_density : Label
@export var ramp_2_stag_temp : Label
@export var ramp_2_stag_press : Label
@export var ramp_2_flow_velocity : Label


@export_category("Ramp 3")
@export var theta_3 : Label
@export var beta_3 : Label
@export var ramp_3_mach_number : Label
@export var ramp_3_temperature : Label
@export var ramp_3_pressure : Label
@export var ramp_3_density : Label
@export var ramp_3_stag_temp : Label
@export var ramp_3_stag_press : Label
@export var ramp_3_flow_velocity : Label


@export_category("Fanno Flow")
@export var fanno_mach_number : Label
@export var fanno_temperature : Label
@export var fanno_pressure : Label
@export var fanno_density : Label
@export var fanno_stag_temp : Label
@export var fanno_stag_press : Label


@export_category("Rayleigh Flow")
@export var rayleigh_mach_number : Label
@export var rayleigh_temperature : Label
@export var rayleigh_pressure : Label
@export var rayleigh_density : Label
@export var rayleigh_stag_temp : Label
@export var rayleigh_stag_press : Label
@export var rayleigh_flow_velocity : Label

@export_category("Exit Properties")
@export var exit_mach_number : Label
@export var exit_temperature : Label
@export var exit_pressure : Label
@export var exit_density : Label
@export var exit_stag_temp : Label
@export var exit_stag_press : Label
@export var exit_flow_velocity : Label

@export_category("Performance")
@export var thrust_generated : Label
@export var drag : Label
@export var net_thrust : Label

@export_category("Nodes")
@export var properties_calculator : InteractiveLabUi

func _on_calculate_again_pressed() -> void:
	properties_calculator.show()
	hide()
