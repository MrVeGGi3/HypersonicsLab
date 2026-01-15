class_name VehicleProperties
extends Node

var vehicle_width : float

var oblique_shock_theta_1 : float
var oblique_shock_theta_2 : float

var ramp_1_height : float
var ramp_2_height : float

var combustion_chamber_height_meters : float
var exaust_nozzle_height_meters : float

var combustion_chamber_diameter_meters : float
var exaust_nozzle_diameter_meters : float

var combustor_area : float
var nozzle_inlet_area : float
var nozzle_outlet_area : float


var vehicle_weight : float

func get_combustion_chamber_diameter():
	var numerator =  4.0 * combustion_chamber_height_meters * vehicle_width
	var denominator = 2.0 * (combustion_chamber_height_meters + vehicle_width)
	combustion_chamber_diameter_meters = (numerator/denominator)
	return combustion_chamber_diameter_meters	

func get_combustor_area():
	combustor_area = combustion_chamber_height_meters * vehicle_width
	return combustor_area

func get_nozzle_inlet():
	nozzle_inlet_area = combustion_chamber_height_meters * vehicle_width
	return nozzle_inlet_area
	
func get_nozzle_outlet():
	nozzle_outlet_area = exaust_nozzle_height_meters * vehicle_width
	return nozzle_outlet_area
