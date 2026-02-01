class_name VRManager
extends Node

@export var vehicle_prop : VehicleProperties
@export var atmo_prop : AtmosfericProperties
@export var ramp_prop : RampProperties
@export var sec_ramp_prop : RampProperties
@export var third_ramp_prop : RampProperties
@export var fanno_flow : FannoFlow
@export var rayleigh_flow : RayleighFlow
@export var flow_exit : FlowExit
@export var vehicle_perf : VehiclePerformance

@export var results_lab : VRLabResults


func assign_vehicle_prop_height(h1 : float , h2 : float, h3 : float, nozzle : float):
	vehicle_prop.ramp_1_height = h1
	vehicle_prop.ramp_2_height = h2
	vehicle_prop.combustion_chamber_height_meters = h3
	vehicle_prop.exaust_nozzle_height_meters = nozzle
	
func assign_vehicle_thetas(theta_1 : float, theta_2 : float, vehicle_w : float):
	vehicle_prop.oblique_shock_theta_1 = theta_1
	vehicle_prop.oblique_shock_theta_2 = theta_2
	vehicle_prop.vehicle_width = vehicle_w

func assign_mach_number(mach : float):
	atmo_prop.mach_number = mach

func assign_altitude(alt : float):
	atmo_prop.update_conditions_at(alt)
	
func assign_fuel_index(index : int):
	fanno_flow.set_fuel_index(index)

func assign_burn_cp(cp : float):
	rayleigh_flow.burn_cp = cp

func start_general_pipeline():
	first_ramp_pipeline()
	second_ramp_pipeline()
	third_ramp_pipeline()
	fanno_flow_pipeline()
	rayleigh_flow_pipeline()
	flow_exit_pipeline()
	vehicle_performance_pipeline()
	update_lab_results()
	debug()
	
func debug():
	print("Drag 1:", vehicle_perf.drag_1)
	print("Drag 2:", vehicle_perf.drag_2)
	print("Exit Sound Velocity:", flow_exit.speed_sound_m_S)
	

func first_ramp_pipeline():
	atmo_prop.set_stagnation_temperature_normal()
	atmo_prop.set_stagnation_pressure_normal()
	atmo_prop.set_velocity()
	ramp_prop.theta = vehicle_prop.oblique_shock_theta_1
	ramp_prop.found_beta(atmo_prop.mach_number, ramp_prop.theta)
	ramp_prop._set_ramp_mach_number(atmo_prop.mach_number)
	ramp_prop._update_properties(atmo_prop.temp_kelvin, atmo_prop.density_kg_m3, atmo_prop.pressure_pa)
	
func second_ramp_pipeline():
	sec_ramp_prop.theta = vehicle_prop.oblique_shock_theta_2
	sec_ramp_prop.found_beta(ramp_prop.mach_number, sec_ramp_prop.theta)
	sec_ramp_prop._set_ramp_mach_number(ramp_prop.mach_number)
	sec_ramp_prop._update_properties(ramp_prop.temp_kelvin, ramp_prop.density_kg_m3, ramp_prop.pressure_pa)

	
func third_ramp_pipeline():
	third_ramp_prop.theta = vehicle_prop.oblique_shock_theta_1 + vehicle_prop.oblique_shock_theta_2
	third_ramp_prop.found_beta(sec_ramp_prop.mach_number, third_ramp_prop.theta)
	third_ramp_prop._set_ramp_mach_number(sec_ramp_prop.mach_number)
	third_ramp_prop._update_properties(sec_ramp_prop.temp_kelvin, sec_ramp_prop.density_kg_m3, sec_ramp_prop.pressure_pa)	
		
func fanno_flow_pipeline():
	fanno_flow.set_four_fld()
	fanno_flow.set_four_fld_1()
	fanno_flow.set_four_fld_2()
	fanno_flow.set_combustor_mass_flow_rate()
	fanno_flow.set_heat_flow_rate_injected()
	fanno_flow.set_temperature_fanno()
	fanno_flow.set_pressure_fanno()
	fanno_flow.set_density_fanno()
	fanno_flow.set_stagnation_temperature_normal()
	fanno_flow.set_fanno_stagnation_pressure()
	
func rayleigh_flow_pipeline():
	rayleigh_flow.gas_constant = fanno_flow.get_air_constant_fanno()
	rayleigh_flow.set_specific_gas_heat_c_pressure()
	rayleigh_flow.set_specific_gas_heat_c_volume()
	rayleigh_flow.set_gamma_by_cp_cv_ratio()
	rayleigh_flow.set_stagnation_temperature_rayleigh()
	rayleigh_flow.mach_number = rayleigh_flow.get_mach_number()
	rayleigh_flow.set_rayleigh_pressure()
	rayleigh_flow.set_rayleigh_temperature()
	rayleigh_flow.set_rayleigh_dens()
	rayleigh_flow.set_rayleigh_stag_press()
	rayleigh_flow.set_velocity()


func flow_exit_pipeline():
	flow_exit.gas_constant = fanno_flow.get_air_constant_fanno()
	flow_exit.set_gamma_stag_pressure_and_temperature()
	flow_exit.set_final_mach_number()
	flow_exit.set_final_temperature()
	flow_exit.set_final_pressure()
	flow_exit.set_final_density()
	flow_exit.set_velocity()

	
func vehicle_performance_pipeline():
	vehicle_perf.calculate_engine_thrust()
	vehicle_perf.calculate_total_drag()
	vehicle_perf.calculate_net_thrust()



func update_lab_results():
	results_lab.atmo_height.text = "Height: %.2f km" % [atmo_prop.actual_height / 1000.0] 
	results_lab.mach_number.text = "Ⓜ︎Mach Number: %.2f" % [atmo_prop.mach_number]
	results_lab.temperature.text = "🌡️Temperature: %.2f K" % [atmo_prop.temp_kelvin]
	results_lab.pressure.text = "☁️Pressure: %.2f Pa" % [atmo_prop.pressure_pa]
	results_lab.density.text = "🧊Density: %.4f kg/m3" % [atmo_prop.density_kg_m3]
	results_lab.stag_press.text = "💣Stag. Press.: %.2f MPa" % [atmo_prop.stagnation_pressure / 1000000.0]
	results_lab.stag_temp.text = "🔥Stag. Temp.: %.2f K" % [atmo_prop.stagnation_temperature]
	results_lab.flow_velocity.text = "❯❯ Flow Velocity.: %.2f m/s" % [atmo_prop.flow_velocity_m_s]
	
	results_lab.theta_1.text = "θ1: %.1f °" % [ramp_prop.theta]
	results_lab.beta_1.text = "β1: %.2f °"  % [ramp_prop.beta]
	results_lab.ramp_1_mach_number.text = "Ⓜ︎Mach Number: %.2f" % [ramp_prop.mach_number]
	results_lab.ramp_1_temperature.text =  "🌡️Temperature: %.2f K" % [ramp_prop.temp_kelvin]
	results_lab.ramp_1_pressure.text = "☁️Pressure: %.2f Pa" % [ramp_prop.pressure_pa]
	results_lab.ramp_1_density.text = "🧊Density: %.4f kg/m3" % [ramp_prop.density_kg_m3]
	results_lab.ramp_1_stag_press.text = "💣Stag. Press.: %.2f MPa" % [ramp_prop.stagnation_pressure / 1000000.0]
	results_lab.ramp_1_stag_temp.text = "🔥Stag. Temp.: %.2f K" % [ramp_prop.stagnation_temperature]
	results_lab.ramp_1_flow_velocity.text = "❯❯ Flow Velocity : %.2f m/s" % [ramp_prop.flow_velocity_m_s]
	
	results_lab.theta_2.text = "θ2: %.1f°" % [sec_ramp_prop.theta]
	results_lab.beta_2.text = "β2: %.2f°" % [sec_ramp_prop.beta]
	results_lab.ramp_2_mach_number.text =  "Ⓜ︎Mach Number: %.2f" % [sec_ramp_prop.mach_number]
	results_lab.ramp_2_temperature.text = "🌡️Temperature: %.2f K" % [sec_ramp_prop.temp_kelvin]
	results_lab.ramp_2_pressure.text = "☁️Pressure : %.2f KPa" % [sec_ramp_prop.pressure_pa / 1000.0]
	results_lab.ramp_2_density.text = "🧊Density: %.4f kg/m3" % [sec_ramp_prop.density_kg_m3]
	results_lab.ramp_2_stag_press.text = "💣Stag. Press.: %.2f MPa" % [sec_ramp_prop.stagnation_pressure / 1000000.0]
	results_lab.ramp_2_stag_temp.text = "🔥Stag. Temp.: %.2f K" % [sec_ramp_prop.stagnation_temperature]
	results_lab.ramp_2_flow_velocity.text = "❯❯ Flow Velocity : %.2f m/s" % [sec_ramp_prop.flow_velocity_m_s]
	
	results_lab.theta_3.text = "θ3: %.1f°" % [third_ramp_prop.theta]
	results_lab.beta_3.text = "β3: %.2f°" % [third_ramp_prop.beta]
	results_lab.ramp_3_mach_number.text = "Ⓜ︎Mach Number: %.2f" % [third_ramp_prop.mach_number]
	results_lab.ramp_3_temperature.text = "🌡️Temperature: %.2f K" % [third_ramp_prop.temp_kelvin]
	results_lab.ramp_3_pressure.text = "☁️Pressure : %.2f Pa" % [third_ramp_prop.pressure_pa]
	results_lab.ramp_3_density.text = "🧊Density: %.4f Kg/m3" % [third_ramp_prop.density_kg_m3]
	results_lab.ramp_3_stag_press.text = "💣Stag. Press.: %.2f MPa" % [third_ramp_prop.stagnation_pressure / 1000000.0]
	results_lab.ramp_3_stag_temp.text = "🔥Stag. Temp.: %.2f K" % [third_ramp_prop.stagnation_temperature]
	results_lab.ramp_3_flow_velocity.text = "❯❯ Flow Velocity : %.2f m/s" % [third_ramp_prop.flow_velocity_m_s]  

	
	results_lab.fanno_mach_number.text = "Ⓜ︎Mach Number: %.2f" % [fanno_flow.mach_number]
	results_lab.fanno_temperature.text = "🌡️Temperature: %.2f K" % [fanno_flow.temp_kelvin]
	results_lab.fanno_pressure.text = "☁️Pressure: %.2f KPa" % [fanno_flow.pressure_pa / 1000.0]
	results_lab.fanno_density.text = "🧊Density: %.4f kg/m3" % [fanno_flow.density_kg_m3]
	results_lab.fanno_stag_press.text = "💣Stag. Press.: %.2f MPa" % [fanno_flow.stagnation_pressure / 1000000.0]
	results_lab.fanno_stag_temp.text = "🔥Stag. Temp.: %.2f K" % [fanno_flow.stagnation_temperature]
	
	
	results_lab.rayleigh_mach_number.text = "Ⓜ︎Mach Number: %.2f" % [rayleigh_flow.mach_number]
	results_lab.rayleigh_temperature.text = "🌡️Temperature : %.2f K" % [rayleigh_flow.temp_kelvin]
	results_lab.rayleigh_pressure.text = "☁️Pressure : %.2f KPa" % [rayleigh_flow.pressure_pa / 1000.0]
	results_lab.rayleigh_density.text = "🧊Density: %.4f kg/m3" % [rayleigh_flow.density_kg_m3]
	results_lab.rayleigh_stag_press.text = "💣Stag. Press.: %.2f MPa" % [rayleigh_flow.stagnation_pressure / 1000000.0]
	results_lab.rayleigh_stag_temp.text = "🔥Stag. Temp.: %.2f K" % [rayleigh_flow.stagnation_temperature]
	results_lab.rayleigh_flow_velocity.text = "❯❯ Flow Velocity: %.2f m/s" % [rayleigh_flow.flow_velocity_m_s]


	results_lab.exit_mach_number.text = "Ⓜ︎Mach Number: %.2f" % [flow_exit.mach_number]
	results_lab.exit_temperature.text = "🌡️Temperature : %.2f K" % [flow_exit.temp_kelvin]
	results_lab.exit_pressure.text = "☁️Pressure : %.2f Pa" % [flow_exit.pressure_pa]
	results_lab.exit_density.text = "🧊Density: %.4f kg/m3" % [flow_exit.density_kg_m3]
	results_lab.exit_stag_press.text = "💣Stag. Press.: %.2f MPa" % [flow_exit.stagnation_pressure / 1000000.0]
	results_lab.exit_stag_temp.text = "🔥Stag. Temp.: %.2f K" % [rayleigh_flow.stagnation_temperature]
	results_lab.exit_flow_velocity.text = "❯❯ Flow Velocity : %.2f m/s" % [flow_exit.flow_velocity_m_s]
	
	results_lab.thrust_generated.text = "⚙️Thrust Generated: %.2f N" % [vehicle_perf.engine_thrust]
	results_lab.drag.text = "💨 Drag: %.2f N" % [vehicle_perf.total_drag]
	results_lab.net_thrust.text = "🚀Net Thrust: %.2f N" % [vehicle_perf.net_thrust]
	
	if vehicle_perf.net_thrust > 0:
		results_lab.net_thrust.modulate = Color.GREEN
	else:
		results_lab.net_thrust.modulate = Color.RED
	results_lab.show()
