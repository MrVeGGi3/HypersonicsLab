class_name Properties
extends Node

var mach_number : float
var pressure_pa : float
var temp_kelvin : float
var density_kg_m3 : float
var speed_sound_m_S : float
var flow_velocity_m_s : float

var gas_constant : float 
var gamma : float


var temperature_ratio : float

var stagnation_temperature : float
var stagnation_pressure : float

const UNIVERSAL_GAS_CONSTANT = 8.314 #j/kg * mol
const AIR_SPECIFIC_GAS_CONSTANT = 287.0 #j/kg * k


var sp_gash_const_press : float  #j/kg * k
var sp_gash_const_volume : float #j/kg * k


const GAMMA_AIR = 1.4 


func _init() -> void:
	gas_constant = AIR_SPECIFIC_GAS_CONSTANT
	gamma = GAMMA_AIR


func pressure_mbar_to_pa(pressure_mbar : float):
	pressure_pa = pressure_mbar * 100
	return pressure_pa


func set_sound_velocity():
	var terms = gamma * gas_constant * temp_kelvin
	speed_sound_m_S = sqrt(terms)
	
func set_flow_velocity():
	flow_velocity_m_s = speed_sound_m_S * mach_number

func set_velocity():
	set_sound_velocity()
	set_flow_velocity()

func set_stagnation_temperature_normal():
	var mach_square = mach_number * mach_number
	var second_term = gamma - 1.0
	var sec_term_div = second_term * mach_square / 2.0
	temperature_ratio = 1.0 + sec_term_div
	stagnation_temperature = temperature_ratio * temp_kelvin

func set_stagnation_pressure_normal():
	var sub_gamma = gamma - 1.0
	var exponent = gamma / sub_gamma
	var pressure_ratio = pow(temperature_ratio, exponent)
	stagnation_pressure = pressure_ratio * pressure_pa
	
func get_cp_by_gas_constant_gamma(gas_cons : float, gam : float):
	sp_gash_const_press = (gam * gas_cons) / (gam - 1.0)
	return sp_gash_const_press

func get_cv_by_gas_constant_gamma(gas_cons : float, gam : float):
	sp_gash_const_volume = gas_cons / (gam - 1.0)

	
	
