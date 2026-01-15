class_name FannoFlow
extends Properties


@export var final_ramp : RampProperties
@export var vehicle_par : VehicleProperties
@export var atmo_properties :  AtmosfericProperties

const FUEL_PRESETS = {
	0 :{ "name" : "Hydrogen",
		"formula" : "H2",
		"molar_mass" : 0.002016, 
		"density" : 70.8,
		"energy" : 120000000.0, 
		"cp" :  14307.0,
		"cv" : 10183.0,
	},
	1 :{"name" : "Methane",
		"formula" : "CH4",
		"molar_mass" : 0.01604,
		"density" : 422.6,
		"energy" : 50000000.0,
		"cp" :  2216.0,
		"cv" : 1708.0
	},
	 2: { "name":  "JP-7", 
		"formula" : "C12H26",
		"molar_mass" : 0.17034,
		"density" : 800.0,
		"energy" : 43500000,
		"cp" :  2010.0,
		"cv" : 1750.0
	},
	 3: { "name":  "Fuel Test", 
		"formula" : "Exercise",
		"molar_mass" : 0.018000,
		"density" : 800.0,
		"energy" : 50000000,
		"cp" :  2010.0,
		"cv" : 1750.0
	}
}

var actual_fuel_index : int = 0
		
var fuel_molar_mass
var friction
var mass_flow_rate
var heat_flow_rate : float

var four_fld : float
var four_fld_1 : float
var four_fld_2 : float

const MAX_ITERATIONS = 5000
const TOLERANCE = 0.0001

var temp_ratio_final 
var temp_ratio_start


func set_fuel_index(index : int):
	actual_fuel_index = index

func get_air_constant_fanno():
	fuel_molar_mass = FUEL_PRESETS[actual_fuel_index]["molar_mass"]
	var fan_gas_constant = UNIVERSAL_GAS_CONSTANT/fuel_molar_mass
	return fan_gas_constant

func set_combustor_mass_flow_rate():
	mass_flow_rate = final_ramp.density_kg_m3 * final_ramp.flow_velocity_m_s * vehicle_par.get_combustor_area()
	
func set_heat_flow_rate_injected():
	set_combustor_mass_flow_rate()
	heat_flow_rate = FUEL_PRESETS[actual_fuel_index]["energy"] / mass_flow_rate

func set_four_fld():
	four_fld =  (4.0 * friction * vehicle_par.vehicle_width) / vehicle_par.get_combustion_chamber_diameter()
	
func set_four_fld_1():
	var g = atmo_properties.gamma
	var m = final_ramp.mach_number
	var m2 = pow(m, 2)
	
	var g_sub = g - 1.0
	var g_add = g + 1.0
	
	var term1 = (1.0 - m2) / (g * m2)
	

	var term2_const =  g_add / (2.0 * g)
	
	var log_num = g_add * m2
	var log_den = 2.0 + g_sub * m2
	var term3_log = log(log_num / log_den)
	
	four_fld_1 = term1 + (term2_const * term3_log)
	
func set_four_fld_2():
	four_fld_2 = four_fld_1 - four_fld
	mach_number = FannoFlowMachSolver.calculate_exit_mach_number(four_fld_2, atmo_properties.gamma)

func _calculate_fanno_value(M: float, gam: float) -> float:
	var M2 = M * M
	var term1_num = 1.0 - M2
	var term1_den = gam * M2
	var term1 = term1_num / term1_den
	
	var term2_const = (gam + 1.0) / (2.0 * gam)
	
	var ln_num = (gam + 1.0) * M2
	var ln_den = 2.0 + (gam - 1.0) * M2
	var term2_ln = log(ln_num / ln_den) # 'log' no Godot é Ln (base e)
	
	return term1 + (term2_const * term2_ln)
	
func get_fanno_temperature_ratio(gam : float, mach : float):
	var gam_sub = gam - 1.0
	var mach_squared = pow(mach, 2.0)
	var num = gam + 1.0
	var term_1 = gam_sub * mach_squared
	var den = term_1 + 2.0
	var temp_ratio = num / den
	return temp_ratio
	
func get_fanno_pressure_ratio(mach : float, temp_ratio : float):
	var first_term =  1.0 / mach
	var second_term = sqrt(temp_ratio)
	var pressure_ratio = first_term * second_term
	return pressure_ratio
	
func get_fanno_density_ratio(mach : float, temp_ratio : float):
	var first_term = 1.0 / mach
	var second_term = 1.0 / temp_ratio
	var second_term_w_extp = sqrt(second_term)
	var density_ratio = first_term * second_term_w_extp
	return density_ratio
	
	
func set_temperature_fanno():
	temp_ratio_final = get_fanno_temperature_ratio(atmo_properties.gamma, mach_number)
	temp_ratio_start = get_fanno_temperature_ratio(atmo_properties.gamma, final_ramp.mach_number)
	var final_ratio = temp_ratio_final / temp_ratio_start
	temp_kelvin = final_ratio * final_ramp.temp_kelvin
	
func set_pressure_fanno():
	var press_ratio_final = get_fanno_pressure_ratio(mach_number, temp_ratio_final)
	var press_ratio_start = get_fanno_pressure_ratio(final_ramp.mach_number, temp_ratio_start)
	pressure_pa = (press_ratio_final / press_ratio_start) * final_ramp.pressure_pa
	
func set_density_fanno():
	var dens_ratio_final = get_fanno_density_ratio(mach_number, temp_ratio_final)
	var dens_ratio_start = get_fanno_density_ratio(final_ramp.mach_number, temp_ratio_start)
	density_kg_m3 = (dens_ratio_final / dens_ratio_start) * final_ramp.density_kg_m3
	
func set_fanno_stagnation_pressure():
	var press_ratio_final = get_fanno_stagnation_pressure_ratio(atmo_properties.gamma, mach_number, temp_ratio_final)
	var press_ratio_start = get_fanno_stagnation_pressure_ratio(atmo_properties.gamma, final_ramp.mach_number, temp_ratio_start)
	stagnation_pressure = (press_ratio_final / press_ratio_start) * final_ramp.stagnation_pressure
 
func get_normal_stag_temp_ratio_normal():
	var mach_square = mach_number * mach_number
	var temp_ratio = 1.0 + ((gamma - 1.0) / 2.0) * mach_square
	return temp_ratio

func set_fanno_stagnation_temperature():
	var start_temp_ratio = get_normal_stag_temp_ratio_normal()
	stagnation_temperature = start_temp_ratio * temp_kelvin

func get_fanno_stagnation_pressure_ratio(gam : float, mach : float, temp_ratio : float):
	var gam_sub = gam - 1.0
	var expo_up = gam + 1.0
	var expo_down = 2.0 * gam_sub
	var expo = expo_up / expo_down
	var first_term = 1.0 / mach
	var temp_inverse = 1.0 / temp_ratio
	var second_term = pow(temp_inverse, expo)
	var stag_press_ratio = first_term * second_term
	return stag_press_ratio

	
