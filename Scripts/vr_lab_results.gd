class_name VRLabResults
extends Node

@export var vr_atmo_prop : XRToolsViewport2DIn3D
@export var vr_ramp_1 : XRToolsViewport2DIn3D
@export var vr_ramp_2 : XRToolsViewport2DIn3D
@export var vr_ramp_3 : XRToolsViewport2DIn3D
@export var vr_fanno : XRToolsViewport2DIn3D
@export var vr_rayleigh : XRToolsViewport2DIn3D
@export var vr_exit : XRToolsViewport2DIn3D
@export var vr_perf_exit : XRToolsViewport2DIn3D

@export_category("Atmosphere Properties")
@onready var atmo_height : Label 
@onready var mach_number : Label
@onready var temperature : Label
@onready var pressure : Label
@onready var density : Label
@onready var stag_temp : Label
@onready var stag_press : Label
@onready var flow_velocity : Label


@export_category("Ramp 1")
@onready var theta_1 : Label
@onready var beta_1 : Label
@onready var ramp_1_mach_number : Label
@onready var ramp_1_temperature : Label
@onready var ramp_1_pressure : Label
@onready var ramp_1_density : Label
@onready var ramp_1_stag_temp : Label
@onready var ramp_1_stag_press : Label
@onready var ramp_1_flow_velocity : Label

@export_category("Ramp 2")
@onready var theta_2 : Label
@onready var beta_2 : Label
@onready var ramp_2_mach_number : Label
@onready var ramp_2_temperature : Label
@onready var ramp_2_pressure : Label
@onready var ramp_2_density : Label
@onready var ramp_2_stag_temp : Label
@onready var ramp_2_stag_press : Label
@onready var ramp_2_flow_velocity : Label


@export_category("Ramp 3")
@onready var theta_3 : Label
@onready var beta_3 : Label
@onready var ramp_3_mach_number : Label
@onready var ramp_3_temperature : Label
@onready var ramp_3_pressure : Label
@onready var ramp_3_density : Label
@onready var ramp_3_stag_temp : Label
@onready var ramp_3_stag_press : Label
@onready var ramp_3_flow_velocity : Label


@export_category("Fanno Flow")
@onready var fanno_mach_number : Label
@onready var fanno_temperature : Label
@onready var fanno_pressure : Label
@onready var fanno_density : Label
@onready var fanno_stag_temp : Label
@onready var fanno_stag_press : Label


@export_category("Rayleigh Flow")
@onready var rayleigh_mach_number : Label
@onready var rayleigh_temperature : Label
@onready var rayleigh_pressure : Label
@onready var rayleigh_density : Label
@onready var rayleigh_stag_temp : Label
@onready var rayleigh_stag_press : Label
@onready var rayleigh_flow_velocity : Label

@export_category("Exit Properties")
@onready var exit_mach_number : Label
@onready var exit_temperature : Label
@onready var exit_pressure : Label
@onready var exit_density : Label
@onready var exit_stag_temp : Label
@onready var exit_stag_press : Label
@onready var exit_flow_velocity : Label

@export_category("Performance")
@onready var thrust_generated : Label
@onready var drag : Label
@onready var net_thrust : Label

@export_category("Viewports")
@onready var vr_atmo_prop_viewport : Viewport
@onready var vr_ramp_1_viewport : Viewport
@onready var vr_ramp_2_viewport : Viewport
@onready var vr_ramp_3_viewport : Viewport
@onready var vr_fanno_viewport : Viewport
@onready var vr_rayleigh_viewport : Viewport
@onready var vr_exit_viewport : Viewport
@onready var vr_perf_viewport : Viewport
var vr_viewports : Array = []


@export_category("Inside Scenes")
var vr_atmo_scene
var vr_ramp_1_scene
var vr_ramp_2_scene
var vr_ramp_3_scene
var vr_fanno_scene
var vr_rayleigh_scene
var vr_exit_scene
var vr_perf_scene

var vr_scenes : Array = []

func _ready() -> void:
	await get_tree().process_frame
	get_viewports()
	adjust_atmo_prop_labels()
	adjust_ramp_1_labels()
	adjust_ramp_2_labels()
	adjust_ramp_3_labels()
	adjust_fanno_labels()
	adjust_rayleigh_labels()
	adjust_perf_labels()
	
	
func get_viewports():
	vr_atmo_prop_viewport = vr_atmo_prop.get_node("Viewport")
	vr_ramp_1_viewport = vr_ramp_1.get_node("Viewport")
	vr_ramp_2_viewport = vr_ramp_2.get_node("Viewport")
	vr_ramp_3_viewport = vr_ramp_3.get_node("Viewport")
	vr_fanno_viewport = vr_fanno.get_node("Viewport")
	vr_rayleigh_viewport = vr_rayleigh.get_node("Viewport")
	vr_exit_viewport = vr_exit.get_node("Viewport")
	vr_perf_viewport = vr_perf_exit.get_node("Viewport")
	
	vr_viewports.append(vr_atmo_prop_viewport)
	vr_viewports.append(vr_ramp_1_viewport)
	vr_viewports.append(vr_ramp_2_viewport)
	vr_viewports.append(vr_ramp_3_viewport)
	vr_viewports.append(vr_fanno_viewport)
	vr_viewports.append(vr_rayleigh_viewport)
	vr_viewports.append(vr_exit_viewport)
	vr_viewports.append(vr_perf_viewport)
	
	find_internal_scenes()

func find_internal_scenes():
	vr_atmo_scene = vr_viewports[0].get_child(0)
	vr_ramp_1_scene = vr_viewports[1].get_child(0)
	vr_ramp_2_scene = vr_viewports[2].get_child(0)
	vr_ramp_3_scene = vr_viewports[3].get_child(0)
	vr_fanno_scene = vr_viewports[4].get_child(0)
	vr_rayleigh_scene = vr_viewports[5].get_child(0)
	vr_exit_scene = vr_viewports[6].get_child(0)
	vr_perf_scene = vr_viewports[7].get_child(0)
	
func adjust_atmo_prop_labels():
	atmo_height = vr_atmo_scene.atmo_prop_height
	mach_number = vr_atmo_scene.atmo_prop_mach_label
	temperature = vr_atmo_scene.atmo_temp_label
	pressure = vr_atmo_scene.atmo_pres_label
	density = vr_atmo_scene.atmo_dens_label
	stag_temp = vr_atmo_scene.atmo_stag_temp_label
	stag_press = vr_atmo_scene.atmo_stag_press_label
	flow_velocity = vr_atmo_scene.flow_vel_label

func adjust_ramp_1_labels():
	theta_1 = vr_ramp_1_scene.theta_1_label
	beta_1 = vr_ramp_1_scene.beta_1_label
	ramp_1_mach_number = vr_ramp_1_scene.mach_number_label
	ramp_1_pressure = vr_ramp_1_scene.pressure_label
	ramp_1_temperature = vr_ramp_1_scene.temperature_label
	ramp_1_density = vr_ramp_1_scene.density_label
	ramp_1_stag_temp = vr_ramp_1_scene.stag_temp_label
	ramp_1_stag_press = vr_ramp_1_scene.stag_press_label
	ramp_1_flow_velocity = vr_ramp_1_scene.flow_velocity_label

func adjust_ramp_2_labels():
	theta_2 = vr_ramp_2_scene.beta_2_label
	beta_2 = vr_ramp_2_scene.beta_2_label
	ramp_2_mach_number = vr_ramp_2_scene.mach_number_label
	ramp_2_pressure = vr_ramp_2_scene.pressure_label
	ramp_2_temperature = vr_ramp_2_scene.temperature_label
	ramp_2_density = vr_ramp_2_scene.density_label
	ramp_2_stag_temp = vr_ramp_2_scene.stag_temp_label
	ramp_2_stag_press = vr_ramp_2_scene.stag_press_label
	ramp_2_flow_velocity = vr_ramp_2_scene.flow_velocity_label

func adjust_ramp_3_labels():
	theta_3 = vr_ramp_3_scene.theta_3_label
	beta_3 = vr_ramp_3_scene.beta_3_label
	ramp_3_mach_number = vr_ramp_3_scene.mach_number_label
	ramp_3_pressure = vr_ramp_3_scene.pressure_label
	ramp_3_temperature = vr_ramp_3_scene.temperature_label
	ramp_3_density = vr_ramp_3_scene.density_label
	ramp_3_stag_temp = vr_ramp_3_scene.stag_temp_label
	ramp_3_stag_press = vr_ramp_3_scene.stag_press_label
	ramp_3_flow_velocity = vr_ramp_3_scene.flow_velocity_label
	
func adjust_fanno_labels():
	fanno_mach_number = vr_fanno_scene.mach_number_label
	fanno_pressure = vr_fanno_scene.pressure_label
	fanno_density = vr_fanno_scene.density_label
	fanno_temperature = vr_fanno_scene.temperature_label
	fanno_density = vr_fanno_scene.density_label
	fanno_stag_temp = vr_fanno_scene.stag_temp_label
	fanno_stag_press = vr_fanno_scene.stag_press_label

func adjust_rayleigh_labels():
	rayleigh_mach_number = vr_rayleigh_scene.mach_number_label
	rayleigh_pressure = vr_rayleigh_scene.pressure_label
	rayleigh_density = vr_rayleigh_scene.density_label
	rayleigh_temperature = vr_rayleigh_scene.temperature_label
	rayleigh_stag_press = vr_rayleigh_scene.stag_press_label
	rayleigh_stag_temp = vr_rayleigh_scene.stag_temp_label
	rayleigh_flow_velocity = vr_rayleigh_scene.flow_velocity_label

func adjust_exit_labels():
	exit_mach_number = vr_exit_scene.mach_number_label
	exit_pressure = vr_exit_scene.pressure_label
	exit_density = vr_exit_scene.density_label
	exit_temperature = vr_exit_scene.temperature_label
	exit_stag_press = vr_exit_scene.stag_press_label
	exit_stag_temp = vr_rayleigh_scene.stag_temp_label
	exit_flow_velocity = vr_rayleigh_scene.flow_velocity_label

func adjust_perf_labels():
	thrust_generated = vr_perf_scene.engine_thrust
	drag = vr_perf_scene.drag
	net_thrust = vr_perf_scene.net_thrust
