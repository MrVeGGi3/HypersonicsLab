class_name FlowExit
extends Properties

@export var vehicle_prop : VehicleProperties
@export var rayleigh_flow : RayleighFlow

var a_throat : float

var temp_ratio_start : float
var temp_ratio_final : float


func get_area_ratio(mach : float):
	var mach_squared = pow(mach, 2.0)
	var gam_add = rayleigh_flow.gamma + 1.0
	var gam_sub = rayleigh_flow.gamma - 1.0
	var first_term = 1.0 / mach_squared
	var second_term_l = 2.0 / gam_add
	var second_term_r = (gam_sub / 2) * mach_squared
	var second_term_r_add = 1.0 + second_term_r
	var expo = gam_add / gam_sub
	var second_term = second_term_l * second_term_r_add
	var exp_second_term = pow(second_term, expo)
	var complete_terms = first_term * exp_second_term
	var area_ratio = sqrt(complete_terms)
	return area_ratio
	
func get_a_throath_size():
	var a_ratio = get_area_ratio(rayleigh_flow.mach_number)
	a_throat = (1.0 / a_ratio) * vehicle_prop.get_nozzle_inlet()
	return a_throat
	
func set_final_mach_number():
	var area_ratio = (vehicle_prop.get_nozzle_outlet() / get_a_throath_size())
	var sqrd_a_ratio = area_ratio * area_ratio
	mach_number = AreaMachSolver.get_mach_from_area_ratio_squared(sqrd_a_ratio, rayleigh_flow.gamma, true)


func get_exit_temp_ratio(mach : float, gam : float):
	var mach_squared = mach * mach
	var gam_sub = gam - 1.0
	var multiplier =  gam_sub / 2.0
	var temp_ratio = multiplier * mach_squared
	var add_temp_ratio = 1.0 + temp_ratio
	return add_temp_ratio

func set_final_temperature():
	temp_ratio_start = get_exit_temp_ratio(rayleigh_flow.mach_number, rayleigh_flow.gamma)
	temp_ratio_final = get_exit_temp_ratio(mach_number, rayleigh_flow.gamma)
	temp_kelvin = (temp_ratio_start / temp_ratio_final) * rayleigh_flow.temp_kelvin
	
func get_exit_pressure_ratio(temp_ratio : float):
	var g_s = rayleigh_flow.gamma - 1.0
	var expo = rayleigh_flow.gamma / g_s
	var t_ratio = pow(temp_ratio, expo)
	return t_ratio

func set_final_pressure():
	var start_press_ratio = get_exit_pressure_ratio(temp_ratio_start)
	var final_press_ratio = get_exit_pressure_ratio(temp_ratio_final)
	pressure_pa = (start_press_ratio / final_press_ratio) * rayleigh_flow.pressure_pa

func get_exit_density_ratio(temp_ratio : float):
	var gam_sub = rayleigh_flow.gamma - 1.0
	var expo = 1.0 / gam_sub
	var dens_ratio = pow(temp_ratio, expo)
	return dens_ratio
	
func set_final_density():
	var start_density_ratio = get_exit_density_ratio(temp_ratio_start)
	var final_density_ratio = get_exit_density_ratio(temp_ratio_final)
	density_kg_m3 = (start_density_ratio / final_density_ratio) * rayleigh_flow.density_kg_m3

func set_gamma_stag_pressure_and_temperature():
	gamma = rayleigh_flow.gamma
	stagnation_temperature = rayleigh_flow.stagnation_temperature
	stagnation_pressure = rayleigh_flow.stagnation_pressure
	
		
	
