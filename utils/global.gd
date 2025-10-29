extends Node


const BGM_THEME = preload("uid://je7u4m541dwf")
const BGM_RUINS = preload("uid://dtvdxt84y1r7i")
const BGM_CYBERPUNK = preload("uid://cb8clc75d23q8")
const BGM_CAVE = preload("uid://ymlvkd8o4mae")
const BGM_FLAT = preload("uid://bdbftcd40rbgx")

func play_bgm(bgm:AudioStream):
	%Bgm.stream=bgm
	%Bgm.play()
func stop_bgm():%Bgm.stop()
func _on_bgm_finished() -> void:%Bgm.play()

const AMBIENT_TUTORIAL = preload("uid://bfaruyeuj7hlq")
const AMBIENT_1 = preload("uid://dc10dikalkq8t")
const AMBIENT_CAVE = preload("uid://beewphvxfjtep")
func play_ambient(ambient:AudioStream):
	%Ambient.stream=ambient
	%Ambient.play()
func stop_ambient():%Ambient.stop()
func _on_ambient_finished() -> void:%Ambient.play()

const SFX_IMPACT = preload("uid://c2isctsk0iub5")
const SFX_IMPACT_1 = preload("uid://ck58vnydx53b4")

const SFX_BUTTON_CLICK = preload("uid://cak5j1u74pllk")
const SFX_SWITCH = preload("uid://c3lkmsp3h40mj")

const SFX_LASER_1 = preload("uid://d1j3poqwtk5c")
const SFX_LASER_3 = preload("uid://dcdf1fgrtrsi7")

const SFX_JUMPER_FIRE = preload("uid://d0gauquut8wh7")
const SFX_JUMPER_JUMP = preload("uid://dibywm646h8rj")
const SFX_JUMPER_LAND = preload("uid://d2s321bgwbgop")

const SFX_BOOM = preload("uid://g5ke2amnrthx")

const SFX_ATTACK = preload("uid://cbywfslpikhew")
const SFX_SPRINT = preload("uid://bfsq4eys8ye7l")
const SFX_STEP_1 = preload("uid://wy2biutkp7vm")
const SFX_STEP_2 = preload("uid://chrys5gsvfbrf")
const SFX_STEP_3 = preload("uid://bbsvrcoc5p51f")
const SFX_DROP = preload("uid://de3lfa4oninkg")
const SFX_JUMP = preload("uid://d3cwyht8qrn0l")
const SFX_HIT = preload("uid://kespeoj5jdqc")
const SFX_HURT = preload("uid://dmf2hhh8vv7os")
const SFX_DEATH = preload("uid://ko45cgd21i7u")
const SFX_AMMOTIME_1 = preload("uid://cwvl1i38oksym")
const SFX_AMMOTIME_3 = preload("uid://bgy5bstrk5tx6")
func play_sfx(sfx:PackedScene):%Sfx.add_child(sfx.instantiate())

const DIALOGUE_C_3_FAILURE_S = preload("uid://mc40vyxc72u2")
const DIALOGUE_C_3_VECTORY_S = preload("uid://budfin8yjlqgj")

const DIALOGUE_C_3_ENTER = preload("uid://birt60wtpnhyd")
func play_dialogue(sfx:PackedScene):%Dialogue.add_child(sfx.instantiate())
func clear_dialogue():for d in %Dialogue.get_children():d.queue_free()

const UI_PRE_ENTER = preload("uid://dyajrc3icedew")
const UI_POLICY = preload("uid://cy2v4yy56kypw")
const UI_THEME = preload("uid://cw11diprqdn11")
const UI_PLAY = preload("uid://b33na2hc1mtcl")
const UI_FAIL = preload("uid://ds2udw36hcry6")
const UI_CLEAR = preload("uid://cy4qt40ba7mq7")
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
func switch_scene(packed_scene:PackedScene):
	var tree:=get_tree()
	var tween:Tween=create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect,"color:a",1,0.5)
	await tween.finished
	
	get_tree().call_deferred("change_scene_to_packed",packed_scene)
	#get_tree().change_scene_to_packed(packed_scene)
	
	await tree.tree_changed
	tween=create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect,"color:a",0,0.5)

var camera_shake:float
func stun(time:float=0.2):
	Engine.time_scale=0.001
	if %TimerStun.is_stopped():%TimerStun.start(0.2)
	else:%TimerStun.start(%TimerStun.time_left+0.2)

func _on_timer_stun_timeout() -> void:
	Engine.time_scale=1

const EFFECT_BOOM = preload("uid://ckl3f6gmbo15j")
const PROJECTILE_1 = preload("uid://db2c1jf6vflq5")
const PROJECTILE_THROWER = preload("uid://cwysknnbfaugv")
const PROJECTILE_FLYER = preload("uid://2lfwbxys80s8")

var ui_play:Play=null
var player:Player=null
var camera:Camera2D=null
var enter_point_order:int
var is_teleportation:bool=false
var name_current_level:String
var is_restart:bool=false
