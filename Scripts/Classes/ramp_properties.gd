class_name RampProperties
extends Properties

@export var atmo_prop : AtmosfericProperties


var m_normal_1 : float
var m_normal_2 : float
var m_normal_squared : float

var density_ratio : float
var pressure_ratio : float

@export_category("Beta-Theta-Mach")
var theta : float = clamp(0.0, 0.0, 90.0)
var beta : float 

func _ready() -> void:
	gas_constant = AIR_SPECIFIC_GAS_CONSTANT

func found_beta(mach : float, the : float):
	beta = Aerodynamics.calculate_weak_beta(mach, the)

func _set_m_normal_1(m_num : float):
	m_normal_1 = m_num * sin(deg_to_rad(beta))

func _set_m_normal_2():
	m_normal_squared = pow(m_normal_1, 2)
	var gam_diff = atmo_prop.gamma - 1.0
	var ratio_1 =  2.0 / gam_diff
	var num = m_normal_squared + ratio_1
	var ratio_2 = (2.0 * atmo_prop.gamma) / gam_diff
	var den = (ratio_2 * m_normal_squared) - 1.0
	m_normal_2 = sqrt(num/den)

func _set_ramp_mach_number(mach_start : float):
	_set_m_normal_1(mach_start)
	_set_m_normal_2()
	var den = sin(deg_to_rad(beta - theta))
	mach_number = (m_normal_2/den)
	
func _set_pressure_ramp(pressure : float):
	var add_gamma = atmo_prop.gamma + 1.0
	var num_2 = (2.0 * atmo_prop.gamma) / add_gamma
	var num_3 = m_normal_squared - 1.0
	var mult = num_2 * num_3
	pressure_ratio = 1.0 + mult
	pressure_pa = pressure_ratio * pressure

func _set_density_ramp(density : float):
	var gam_add = atmo_prop.gamma + 1.0
	var gam_sub = atmo_prop.gamma - 1.0
	var num = gam_add * m_normal_squared
	var den = gam_sub * m_normal_squared
	var final_den = den + 2.0
	density_ratio = num / final_den
	density_kg_m3 = density_ratio * density
	
func _set_temperature_ramp(temperature : float):
	temperature_ratio = pressure_ratio/density_ratio
	temp_kelvin = temperature_ratio * temperature
	
	
func _update_properties(temp : float, dens : float, press : float):
	_set_pressure_ramp(press)
	_set_density_ramp(dens)
	_set_temperature_ramp(temp)
	set_stagnation_temperature_normal()
	set_stagnation_pressure_normal()
	set_velocity()
