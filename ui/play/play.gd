extends Node2D

@onready var current_level: Level = null

const LEVEL_CAVE = preload("uid://l6m7am4bx8hx")
const LEVEL_RUINS = preload("uid://c1cnf4qh4sn0o")
const LEVEL_SEWER = preload("uid://c4m7w371a50xy")
const LEVEL_CITY = preload("uid://ctoymaqneykpq")
const LEVEL_CYBERPUNK = preload("uid://xe1j7c2ii011")
var map_level={
	"level_cave":LEVEL_CAVE,
	"level_ruins":LEVEL_RUINS,
	"level_sewer":LEVEL_SEWER,
	"level_city":LEVEL_CITY,
	"level_cyberpunk":LEVEL_CYBERPUNK,
	
}
func switch_level(name_level:String):
	var packed_level=map_level[name_level]
	if packed_level:
		var new_level:Level=packed_level.instantiate()
		%Level.call_deferred("add_child",new_level)
		if current_level:current_level.queue_free()
		current_level=new_level

func _ready() -> void:
	Global.player=%Player
	Global.camera=%Camera2D
	current_level=%Level.get_child(0)
	current_level.set_camera_limit()
	#switch_level("level_cyberpunk")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("tab"):Engine.time_scale=0.15
	if Input.is_action_just_released("tab"):Engine.time_scale=1
	
	var shader_greyscale:ShaderMaterial=%ColorRect.material
	var shader_greyscale_v=shader_greyscale.get_shader_parameter("intensity")
	if Input.is_action_pressed("tab"):shader_greyscale_v=lerpf(shader_greyscale_v,1.0,0.1)
	else:shader_greyscale_v=lerpf(shader_greyscale_v,0.0,0.1)
	shader_greyscale.set_shader_parameter("intensity",shader_greyscale_v)
