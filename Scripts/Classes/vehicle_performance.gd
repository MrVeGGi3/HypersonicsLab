class_name VehiclePerformance
extends Node


@export var first_ramp : RampProperties
@export var second_ramp : RampProperties

@export var vehicle_prop : VehicleProperties
@export var fanno_flow : FannoFlow
@export var rayleigh_flow : RayleighFlow
@export var flow_exit : FlowExit

var engine_thrust : float
var total_drag : float
var net_thrust : float

func calculate_engine_thrust():
	var velocity_diff = flow_exit.flow_velocity_m_s - rayleigh_flow.flow_velocity_m_s
	var exit_product = flow_exit.pressure_pa * vehicle_prop.nozzle_outlet_area
	var entry_product = rayleigh_flow.pressure_pa * vehicle_prop.nozzle_inlet_area
	engine_thrust = exit_product + (fanno_flow.mass_flow_rate * velocity_diff) - entry_product
	
	
func calculate_total_drag():
	var drag_1 = first_ramp.pressure_pa * vehicle_prop.ramp_1_height * vehicle_prop.vehicle_width
	var drag_2 = second_ramp.pressure_pa * vehicle_prop.ramp_2_height * vehicle_prop.vehicle_width
	
	total_drag = drag_1 + drag_2
	

func calculate_net_thrust():
	net_thrust = engine_thrust - total_drag
	
	
	
	
