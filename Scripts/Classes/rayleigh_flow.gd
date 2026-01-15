class_name RayleighFlow
extends Properties


@export var fanno_flow : FannoFlow
@export var atmo_prop : AtmosfericProperties

var press_ratio_start : float
var press_ratio_final : float
@export var burn_cp : float = 2400.0

func set_specific_gas_heat_c_pressure():
	sp_gash_const_press = burn_cp

func set_specific_gas_heat_c_volume():
	sp_gash_const_volume = sp_gash_const_press - gas_constant
		
func set_gamma_by_cp_cv_ratio():
	gamma = sp_gash_const_press/sp_gash_const_volume


func set_stagnation_temperature_rayleigh():
	stagnation_temperature = (fanno_flow.heat_flow_rate + atmo_prop.get_cp_by_gas_constant_gamma(AIR_SPECIFIC_GAS_CONSTANT, atmo_prop.gamma) * fanno_flow.stagnation_temperature) / burn_cp
	
func get_stag_temp_ratio(gam : float, mach : float):
	var mach_squared = pow(mach, 2.0)
	var gam_sub = gam - 1.0
	var gam_add = gam + 1.0
	var up_term = gam_add * mach_squared
	var base_down = gam * mach_squared
	var base_down_add = 1.0 + base_down
	var down_term = pow(base_down_add, 2.0)
	var multiplier = gam_sub * mach_squared
	var multiplier_add = 2.0 + multiplier
	var temp_ratio = (up_term / down_term) * multiplier_add
	return temp_ratio
	
func get_mach_number(): 
	var gamma_in = atmo_prop.gamma
	var temp_ratio_entrada = get_stag_temp_ratio(gamma_in, fanno_flow.mach_number)
	
	# 2. Calcula o Ratio Total (Alvo)
	# Nota: Certifique-se que stagnation_temperature já é a T0_final somada
	temperature_ratio = (stagnation_temperature / fanno_flow.stagnation_temperature) * temp_ratio_entrada
	
	
	# 3. Solver usa o GAMMA DE COMBUSTÃO (Ex: 1.25)
	var g = gamma # <--- AQUI ESTAVA O RISCO
	var g2 = pow(g, 2.0)
	var K = temperature_ratio
	
	# --- RESTO DA MATEMÁTICA (IGUAL A SUA) ---
	var A = K * g2 - (g2 - 1.0)
	var B = 2.0 * K * g - 2.0 * (g + 1.0)
	var C = K
	
	if is_zero_approx(A): return sqrt(-C/B) if B != 0 else -1.0
	
	var delta = (B * B) - (4.0 * A * C)
	
	if delta < 0.0:
		push_warning("Rayleigh: Choque Térmico (M=1).")
		return 1.0
		
	var sqrt_delta = sqrt(delta)
	var m2_sol1 = (-B - sqrt_delta) / (2.0 * A)
	var m2_sol2 = (-B + sqrt_delta) / (2.0 * A)
	
	var m_candidates : Array[float] = []
	if m2_sol1 > 0: m_candidates.append(sqrt(m2_sol1))
	if m2_sol2 > 0: m_candidates.append(sqrt(m2_sol2))
	
	if m_candidates.is_empty(): return -1.0
	
	# Lógica Scramjet: Queremos a solução Supersônica (Maior Mach)
	return m_candidates.max()
	
	
func get_pressure_ratio(gam : float, mach : float):
	var mach_squared = pow(mach, 2.0)
	var num = 1.0 + gam
	var term_1 = gam * mach_squared
	var den = 1.0 + term_1
	var pressure_ratio = num / den
	return pressure_ratio
	
			
func set_rayleigh_pressure():
	press_ratio_start = get_pressure_ratio(atmo_prop.gamma, fanno_flow.mach_number)
	press_ratio_final = get_pressure_ratio(gamma, mach_number)
	var press_ratio = (press_ratio_final / press_ratio_start)
	pressure_pa = press_ratio * fanno_flow.pressure_pa	

func get_temperature_ratio(mach : float, pres_ratio : float):
	var term_1 = pow(mach, 2.0)
	var term_2 = pow(pres_ratio, 2.0)
	var temp_ratio = term_1 * term_2
	return temp_ratio
	
	

func set_rayleigh_temperature():
	var temp_ratio_start = get_temperature_ratio(fanno_flow.mach_number, press_ratio_start)
	var temp_ratio_final = get_temperature_ratio(mach_number, press_ratio_final)
	var temp_ratio = temp_ratio_final / temp_ratio_start
	temp_kelvin = temp_ratio * fanno_flow.temp_kelvin


func get_rayleigh_dens_ratio(mach : float, pres_ratio : float):
	var term_1 = pow(mach, 2.0)
	var term_2 = 1.0 / pres_ratio
	var term_3 = (1.0 / term_1) 
	var dens_ratio = term_3 * term_2	
	return dens_ratio
	
func set_rayleigh_dens():
	var dens_ratio_start = get_rayleigh_dens_ratio(fanno_flow.mach_number, press_ratio_start)
	var dens_ratio_final = get_rayleigh_dens_ratio(mach_number, press_ratio_final)
	density_kg_m3 = (dens_ratio_final / dens_ratio_start) * fanno_flow.density_kg_m3


func get_stag_press_ratio(gam : float, mach : float):
	var gam_add = 1.0 + gam
	var gam_sub = gam - 1.0
	var mach_squared = mach * mach
	
	var l_term_down = 1.0 + (gam * mach_squared)
	var l_term = gam_add / l_term_down
	
	var r_term_up = 2.0 + (gam_sub * mach_squared)
	var r_term = r_term_up / gam_add
	
	var expo = gam / gam_sub
	var r_term_expo = pow(r_term, expo)
	
	var stag_press_ratio = l_term * r_term_expo
	return stag_press_ratio
	
	
func set_rayleigh_stag_press():
	var stag_press_start = get_stag_press_ratio(atmo_prop.gamma, fanno_flow.mach_number)
	var stag_press_final = get_stag_press_ratio(gamma, mach_number)
	stagnation_pressure = (stag_press_final / stag_press_start) * fanno_flow.stagnation_pressure
