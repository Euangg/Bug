class_name Play
extends Control

var current_level: Level = null

const LEVEL_RUINS = preload("uid://c1cnf4qh4sn0o")
const LEVEL_SEWER = preload("uid://c4m7w371a50xy")
const LEVEL_CITY = preload("uid://ctoymaqneykpq")
const LEVEL_CYBERPUNK = preload("uid://xe1j7c2ii011")
const LEVEL_BAR = preload("uid://cey0hy37clu11")
const LEVEL_STREET = preload("uid://c0mq03nfqmt8l")
const LEVEL_CAVE_1 = preload("uid://l6m7am4bx8hx")
const LEVEL_CAVE_2 = preload("uid://dtab1ex720nxt")
const LEVEL_CAVE_3 = preload("uid://j4ss5o1avea6")
const LEVEL_CHURCH = preload("uid://sb377ee0lgks")
const LEVEL_TEST = preload("uid://dn7bycqqe64nc")


signal level_switched

var map_level={
	"level_ruins":LEVEL_RUINS,
	"level_sewer":LEVEL_SEWER,
	"level_city":LEVEL_CITY,
	"level_cyberpunk":LEVEL_CYBERPUNK,
	"level_bar":LEVEL_BAR,
	"level_street":LEVEL_STREET,
	"level_cave_1":LEVEL_CAVE_1,
	"level_cave_2":LEVEL_CAVE_2,
	"level_cave_3":LEVEL_CAVE_3,
	"level_church":LEVEL_CHURCH,
	"level_test":LEVEL_TEST
}
func switch_level(name_level:String):
	var packed_level=map_level[name_level]
	Global.play_sfx(Global.SFX_SWITCH)
	if packed_level:
		player.clear_dead_connections()
		player.dead.connect(func():%TimerEnd.start())
		clear_dialogue_connections()
		var new_level:Level=packed_level.instantiate()
		%Level.call_deferred("add_child",new_level)
		if current_level:current_level.queue_free()
		current_level=new_level
		Global.name_current_level=name_level
func on_level_switched():
	var mark:Marker2D=current_level.enter_point.get_child(Global.enter_point_order)
	if mark: %Player.position=mark.position
	current_level.set_camera_limit()
	for g in %Player.node_ghost.get_children():g.queue_free()
	%TimerTeleporation.start()
	
	var tween:Tween=create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(Global.color_rect,"color:a",0,0.5)

@onready var player: Player = %Player
@onready var dialogue: AudioStreamPlayer = %Dialogue
func _ready() -> void:
	Global.ui_play=self
	level_switched.connect(on_level_switched)
	Global.camera=%Camera2D
	current_level=%Level.get_child(0)
	current_level.set_camera_limit()
	%Player.dead.connect(func():%TimerEnd.start())
	dialogue.finished.connect(func():Global.switch_scene(Global.UI_FAIL))
	#switch_level("level_church")
	if Global.is_restart:switch_level(Global.name_current_level)
	

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("tab"):
		Engine.time_scale=0.15
		Global.play_sfx(Global.SFX_AMMOTIME_1)
		%SfxAmmotime.play()
	if Input.is_action_pressed("tab"):Engine.time_scale=0.15
	if Input.is_action_just_released("tab"):
		Engine.time_scale=1
		Global.play_sfx(Global.SFX_AMMOTIME_3)
		%SfxAmmotime.stop()
		
	#if Input.is_action_just_pressed("q"):show_curtain()
	#if Input.is_action_just_released("q"):hide_curtain()
	
	if is_zero_approx(Global.camera_shake):pass
	else:
		%Camera2D.offset=Vector2(
			randf_range(-Global.camera_shake,Global.camera_shake),
			randf_range(-Global.camera_shake,Global.camera_shake)
		)
		Global.camera_shake=move_toward(Global.camera_shake,0,60*delta)
	
	var shader_greyscale:ShaderMaterial=%ColorRect.material
	var shader_greyscale_v=shader_greyscale.get_shader_parameter("intensity")
	if Input.is_action_pressed("tab"):shader_greyscale_v=lerpf(shader_greyscale_v,1.0,0.1)
	else:shader_greyscale_v=lerpf(shader_greyscale_v,0.0,0.1)
	shader_greyscale.set_shader_parameter("intensity",shader_greyscale_v)

func _on_timer_teleporation_timeout() -> void:
	Global.is_teleportation=false

func _on_sfx_ammotime_finished() -> void:%SfxAmmotime.play()

func _on_timer_end_timeout() -> void:
	Global.switch_scene(Global.UI_FAIL)

func show_curtain(p_dialogue:Resource):
	%Level.set_deferred("process_mode",PROCESS_MODE_DISABLED)
	player.set_deferred("process_mode",PROCESS_MODE_DISABLED)
	%Curtain.visible=true
	Global.clear_dialogue()
	dialogue.stream=p_dialogue
	dialogue.play()
func hide_curtain():
	%Level.process_mode=Node.PROCESS_MODE_INHERIT
	%Player.process_mode=Node.PROCESS_MODE_INHERIT
	%Curtain.visible=false

func clear_dialogue_connections():
	var connections=dialogue.get_signal_connection_list("finished")
	for c in connections:dialogue.finished.disconnect(c["callable"])
