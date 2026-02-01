class_name  VRInteractiveLabUi
extends Control

@onready var altitude_slider : VSlider = $AltitudeControl/AltitudeSlider
@onready var altitude_sbox : SpinBox = $AltitudeControl/AltitudeSpinBox
@onready var mach_slider : HSlider = $MachControl/MachSlider
@onready var mach_sbox : SpinBox = $MachControl/MachSpinBox
@onready var fuel_type : OptionButton = $FuelControl/VBoxContainer/FuelType
@onready var burn_cp_sbox : SpinBox = $CPBurnControl/VBoxContainer/CPSpinBox

@onready var energy_gen : Label = $EnergyFuelControl/VBoxContainer/Energy


@export var rayleigh_flow : RayleighFlow
@export var fanno_flow : FannoFlow
@export var manager : VRManager

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
var can_update : bool = false

func _ready() -> void:
	await get_tree().process_frame
	generate_fuel_options()
	set_initial_cp()
	var energy_text = fanno_flow.FUEL_PRESETS[0]["energy"] / 1000000.0
	energy_gen.text = "%.2f MJ" % [energy_text]
	can_update = true

func set_initial_cp():
	burn_cp_sbox.value = rayleigh_flow.burn_cp

func _on_altitude_slider_value_changed(value: float) -> void:
	altitude_sbox.value = value
	altitude = value
	generate_values()

func _on_altitude_spin_box_value_changed(value: float) -> void:
	altitude_slider.value = value
	altitude = value
	generate_values()

func _on_mach_slider_value_changed(value: float) -> void:
	mach_sbox.value = value
	mach_number = value
	generate_values()
	
func _on_mach_spin_box_value_changed(value: float) -> void:
	mach_slider.value = value
	mach_number = value
	generate_values()
	
	
func generate_fuel_options():
	fuel_type.clear()
	for i in fanno_flow.FUEL_PRESETS:
		var data = fanno_flow.FUEL_PRESETS[i]
		fuel_type.add_item(data["name"], i)	
		


func generate_values():
	if can_update:
		manager.assign_vehicle_prop_height(h1, h2, h3, he)
		manager.assign_fuel_index(fuel_index)
		manager.assign_vehicle_thetas(theta_1, theta_2, vehicle_width)
		manager.assign_mach_number(mach_number)
		manager.assign_altitude(altitude)
		manager.assign_burn_cp(burn_cp)
		manager.start_general_pipeline()
		hide()
	else:
		return

func _on_fuel_type_item_selected(index: int) -> void:
	fuel_index = index
	var energy_text = fanno_flow.FUEL_PRESETS[index]["energy"] / 1000000.0
	energy_gen.text = "%.2f MJ" % [energy_text]
	generate_values()


func _on_theta_1_value_changed(value: float) -> void:
	theta_1 = value
	generate_values()
	
func _on_theta_2_value_changed(value: float) -> void:
	theta_2 = value
	generate_values()

func _on_h_1_value_changed(value: float) -> void:
	h1 = value
	generate_values()

func _on_h_2_value_changed(value: float) -> void:
	h2 = value
	generate_values()

func _on_h_3_value_changed(value: float) -> void:
	h3 = value
	generate_values()

func _on_out_nozzle_height_value_changed(value: float) -> void:
	he = value
	generate_values()

func _on_spin_box_value_changed(value: float) -> void:
	vehicle_width = value
	generate_values()

func _on_friction_spin_box_value_changed(value: float) -> void:
	fanno_flow.friction = value
	generate_values()

func _on_cp_spin_box_value_changed(value: float) -> void:
	burn_cp = value
	generate_values()
