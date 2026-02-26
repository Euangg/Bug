class_name Play
extends Control

@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var player: Player = %Player
@onready var dialogue: AudioStreamPlayer = %Dialogue

var dict_level={
	"level_ruins":("uid://c1cnf4qh4sn0o"),
	"level_sewer":("uid://c4m7w371a50xy"),
	"level_city":("uid://ctoymaqneykpq"),
	"level_cyberpunk":("uid://xe1j7c2ii011"),
	"level_bar":("uid://cey0hy37clu11"),
	"level_apartment":("uid://be1q8fgeey1e"),
	"level_street":("uid://c0mq03nfqmt8l"),
	"level_cave_1": ("uid://l6m7am4bx8hx"),
	"level_cave_2": ("uid://dtab1ex720nxt"),
	"level_cave_3":("uid://j4ss5o1avea6"),
	"level_church":("uid://sb377ee0lgks"),
	"level_test":("uid://dn7bycqqe64nc")
}
func switch_level(str_level:String):
	print("switch 2 "+ str_level )
	var old_level:Array=%Level.get_children()
	for l in old_level:l.queue_free()
	
	var new_level:Level=load(dict_level[str_level]).instantiate()
	%Level.add_child(new_level)
	Global.str_current_level=str_level
	Global.play_sfx(Global.SFX_SWITCH)
	
	var marks=new_level.enter_point.get_children()
	%Player.position=marks[0].position
	
	camera_2d.limit_left=new_level.lt.position.x
	camera_2d.limit_top=new_level.lt.position.y
	camera_2d.limit_right=new_level.rb.position.x
	camera_2d.limit_bottom=new_level.rb.position.y
	
	for g in %Player.node_ghost.get_children():g.queue_free()
	%TimerTeleporation.start()
	var tween:Tween=create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(Global.color_rect,"color:a",0,0.5)

func _ready() -> void:
	Global.camera=%Camera2D
	if Global.is_restart:switch_level(Global.str_current_level)
	else:switch_level("level_ruins")

	%Player.dead.connect(func():
		print("dead")
		%TimerEnd.start())
	dialogue.finished.connect(func():Global.switch_scene(Global.UI_FAIL))
	
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
