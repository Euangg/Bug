extends Node

const BGM_THEME = preload("uid://je7u4m541dwf")
const BGM_TUTORIAL_FIGHT = preload("uid://owhembhwnf8j")
const BGM_TUTORIAL_MIDDLE = preload("uid://dtvdxt84y1r7i")
const BGM_1 = preload("uid://bdbftcd40rbgx")
const BGM_1_FIGHT = preload("uid://cb8clc75d23q8")
func play_bgm(bgm:AudioStream):
	%Bgm.stream=bgm
	%Bgm.play()
func _on_bgm_finished() -> void:%Bgm.play()

const AMBIENT_TUTORIAL = preload("uid://bfaruyeuj7hlq")
const AMBIENT_1 = preload("uid://dc10dikalkq8t")
func play_ambient(ambient:AudioStream):
	%Ambient.stream=ambient
	%Ambient.play()
func _on_ambient_finished() -> void:%Ambient.play()

const SFX_IMPACT = preload("uid://c2isctsk0iub5")
const SFX_IMPACT_1 = preload("uid://ck58vnydx53b4")
const SFX_BUTTON_CLICK = preload("uid://cak5j1u74pllk")
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
func play_sfx(sfx:PackedScene):%Sfx.add_child(sfx.instantiate())

const UI_THEME = preload("uid://cw11diprqdn11")
const UI_PLAY = preload("uid://b33na2hc1mtcl")
const UI_FAIL = preload("uid://ds2udw36hcry6")
const UI_CLEAR = preload("uid://cy4qt40ba7mq7")
func switch_scene(packed_scene:PackedScene):
	get_tree().call_deferred("change_scene_to_packed",packed_scene)

const EFFECT_BOOM = preload("uid://ckl3f6gmbo15j")

var player:Player=null
var camera:Camera2D=null
var is_player_entered:bool=false
var enter_point_order:int
