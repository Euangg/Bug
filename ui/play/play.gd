class_name Play
extends Control

@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var player: Player = %Player
@onready var dialogue: AudioStreamPlayer = %Dialogue

var dict_level={
	"1-1":("uid://c1cnf4qh4sn0o"),
	"1-2":("uid://dtab1ex720nxt"),
	"1-3":("uid://j4ss5o1avea6"),
	"1-4":("uid://dxyuas23t6y4y"),
	
	"2-1":("uid://l6m7am4bx8hx"),
	"2-2":("uid://c4m7w371a50xy"),
	"2-3":("uid://ctoymaqneykpq"),
	"2-4":("uid://dn7bycqqe64nc"),
	"2-5":("uid://xe1j7c2ii011"),
	
	"3-1":("uid://cey0hy37clu11"),
	"3-2":("uid://be1q8fgeey1e"),
	"3-3":("uid://c0mq03nfqmt8l"),
	"3-4":("uid://sb377ee0lgks"),
}
func switch_level(str_level:String,order:int=0):
	print("switch to "+ str_level )
	var old_level:Array=%Level.get_children()
	for l in old_level:l.queue_free()
	
	var new_level:Level=load(dict_level[str_level]).instantiate()
	%Level.add_child(new_level)
	Global.str_current_level=str_level
	Global.play_sfx(Global.SFX_SWITCH)
	
	var marks=new_level.enter_point.get_children()
	%Player.position=marks[order].position
	
	camera_2d.limit_left=new_level.lt.position.x
	camera_2d.limit_top=new_level.lt.position.y
	camera_2d.limit_right=new_level.rb.position.x
	camera_2d.limit_bottom=new_level.rb.position.y
	
	for g in %Player.node_ghost.get_children():g.queue_free()
	%TimerTeleporation.start()
	
	get_tree().paused=false
	var tween:Tween=create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(Global.color_rect,"color:a",0,0.5)

func _ready() -> void:
	Global.camera=%Camera2D
	switch_level(Global.str_enter_level)
	
	%Player.dead.connect(func():
		print("dead")
		%TimerEnd.start())
	dialogue.finished.connect(func():Global.switch_scene(Global.UI_FAIL))
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):Global.switch_scene(Global.UI_THEME)
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
