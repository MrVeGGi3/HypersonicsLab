extends VBoxContainer

@export var manager : Manager
@export var atmo_prop : AtmosfericProperties


@export_category("Labels")
@export var atmospheric_pressure : Label
@export var atmospheric_temperature : Label
@export var atmospheric_density : Label
@export var atmostagnation_temperature : Label
@export var atmostagnation_pressure : Label
@export var sound_velocity_label : Label
@export var flow_velocity_label : Label


@export_category("Spinboxes")
@export var mach_number_value : SpinBox
@export var altitude_value : SpinBox

@export_category("Sliders")
@export var mach_slider : HSlider
@export var altitude_slider : HSlider


func _ready() -> void:
	atmo_prop.gamma = atmo_prop.GAMMA_AIR
	atmo_prop.gas_constant = atmo_prop.AIR_SPECIFIC_GAS_CONSTANT
	mach_number_value.value = mach_slider.value
	altitude_value.value = altitude_slider.value
	
func _update_atmo_stats():
	atmospheric_pressure.text = "%.2f Pa" % [atmo_prop.pressure_pa]
	atmospheric_density.text  = "%.4f kg/m3" % [atmo_prop.density_kg_m3]
	atmospheric_temperature.text = "%.2f K" % [atmo_prop.temp_kelvin]
	atmostagnation_temperature.text = "%.2f K" % [atmo_prop.stagnation_temperature]
	atmostagnation_pressure.text = "%.2f Pa" % [atmo_prop.stagnation_pressure]

func _update_sound_vel_stats():
	sound_velocity_label.text = "Sound Velocity: %.2f m/s" % [atmo_prop.get_sound_velocity()]
	flow_velocity_label.text = "Flow Velocity: %.2f m/s" % [atmo_prop.get_flow_velocity()]
	atmostagnation_temperature.text = "Stag. Temperature %.2f K" % [atmo_prop.get_stagnation_temperature_normal()]
	atmostagnation_pressure.text = "Stag. Pressure : %.2f Pa" % [atmo_prop.get_stagnation_pressure_normal()]
	

func change_altitude(value : float):
	atmo_prop.update_conditions_at(value)
	_update_atmo_stats()
	_update_sound_vel_stats()
	

func _on_mach_number_slider_value_changed(value: float) -> void:
	mach_number_value.value = value
	atmo_prop.mach_number = value
	_update_sound_vel_stats()


func _on_altitude_slider_value_changed(value: float) -> void:
	altitude_value.value = value
	atmo_prop.actual_height = value
	change_altitude(value)


func _on_mach_number_spin_box_value_changed(value: float) -> void:
	mach_number_value.value = value
	atmo_prop.mach_number = value
	_update_sound_vel_stats()
	

func _on_altitude_spin_box_value_changed(value: float) -> void:
	altitude_slider.value = value
	atmo_prop.actual_height = value
	change_altitude(value)
