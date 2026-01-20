class_name  InteractiveLabUi
extends Control

@export var altitude_slider : VSlider
@export var altitude_sbox : SpinBox
@export var mach_slider : HSlider
@export var mach_sbox : SpinBox
@export var fuel_type : OptionButton
@export var burn_cp_sbox : SpinBox

@export var energy_gen : Label


@export var rayleigh_flow : RayleighFlow
@export var fanno_flow : FannoFlow
@export var manager : Manager

var h1 : float
var h2 : float
var h3 : float
var he : float
var mach_number : float
var altitude : float
var theta_1 : float
var theta_2 : float
var vehicle_width : float

var fuel_index : int
var burn_cp : float

func _ready() -> void:
	generate_fuel_options()
	set_initial_cp()

func set_initial_cp():
	burn_cp_sbox.value = rayleigh_flow.burn_cp

func _on_altitude_slider_value_changed(value: float) -> void:
	altitude_sbox.value = value
	altitude = value

func _on_altitude_spin_box_value_changed(value: float) -> void:
	altitude_slider.value = value
	altitude = value

func _on_mach_slider_value_changed(value: float) -> void:
	mach_sbox.value = value
	mach_number = value
	
func _on_mach_spin_box_value_changed(value: float) -> void:
	mach_slider.value = value
	mach_number = value
	
	
func generate_fuel_options():
	fuel_type.clear()
	for i in fanno_flow.FUEL_PRESETS:
		var data = fanno_flow.FUEL_PRESETS[i]
		fuel_type.add_item(data["name"], i)	
		
func _on_generate_pressed() -> void:
	generate_values()


func generate_values():
	manager.assign_vehicle_prop_height(h1, h2, h3, he)
	manager.assign_fuel_index(fuel_index)
	manager.assign_vehicle_thetas(theta_1, theta_2, vehicle_width)
	manager.assign_mach_number(mach_number)
	manager.assign_altitude(altitude)
	manager.assign_burn_cp(burn_cp)
	manager.start_general_pipeline()
	hide()

func _on_fuel_type_item_selected(index: int) -> void:
	fuel_index = index
	var energy_text = fanno_flow.FUEL_PRESETS[index]["energy"] / 1000000.0
	energy_gen.text = "%.2f MJ" % [energy_text]


func _on_theta_1_value_changed(value: float) -> void:
	theta_1 = value
	
func _on_theta_2_value_changed(value: float) -> void:
	theta_2 = value

func _on_h_1_value_changed(value: float) -> void:
	h1 = value

func _on_h_2_value_changed(value: float) -> void:
	h2 = value

func _on_h_3_value_changed(value: float) -> void:
	h3 = value

func _on_out_nozzle_height_value_changed(value: float) -> void:
	he = value

func _on_spin_box_value_changed(value: float) -> void:
	vehicle_width = value

func _on_friction_spin_box_value_changed(value: float) -> void:
	fanno_flow.friction = value

func _on_cp_spin_box_value_changed(value: float) -> void:
	burn_cp = value
