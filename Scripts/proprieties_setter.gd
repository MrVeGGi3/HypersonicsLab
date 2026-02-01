class_name PropertiesSetter
extends Node

@export var lab_ui_viewport : XRToolsViewport2DIn3D

@onready var fanno_flow = $"../../FannoFlow"
@onready var rayleigh_flow = $"../../RayleighFlow"
@onready var manager = $"../../VrManager"

var lab_viewport
var lab_scene

func _ready() -> void:
	await get_tree().process_frame
	lab_viewport = lab_ui_viewport.get_node("Viewport")
	lab_scene = lab_viewport.get_child(0)
	
	lab_scene.fanno_flow = fanno_flow
	lab_scene.rayleigh_flow = rayleigh_flow
	lab_scene.manager = manager
	
