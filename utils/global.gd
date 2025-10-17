extends Node

const BGM_THEME = preload("uid://je7u4m541dwf")
const BGM_TUTORIAL_FIGHT = preload("uid://owhembhwnf8j")
const BGM_TUTORIAL_MIDDLE = preload("uid://dtvdxt84y1r7i")
func play_bgm(bgm:AudioStream):
	%Bgm.stream=bgm
	%Bgm.play()
func _on_bgm_finished() -> void:%Bgm.play()

const AMBIENT_TUTORIAL = preload("uid://bfaruyeuj7hlq")
func play_ambient(ambient:AudioStream):
	%Ambient.stream=ambient
	%Ambient.play()
func _on_ambient_finished() -> void:%Ambient.play()

const SCENE_PLAY = preload("uid://b33na2hc1mtcl")
func switch_scene(packed_scene:PackedScene):
	get_tree().call_deferred("change_scene_to_packed",packed_scene)


const LEVEL_1 = preload("uid://ypx6fceqgao6")
const LEVEL_2 = preload("uid://dxyuas23t6y4y")
var map_level={
	"level_1":LEVEL_1,
	"level_2":LEVEL_2,
}
var player:Player=null
var camera:Camera2D=null
var current_level:Level
var is_player_entered:bool=false
var enter_point_order:int
func switch_level(name_level:String):
	var packed_level=map_level[name_level]
	if packed_level:
		var node_level=current_level.get_parent()
		var new_level:Level=packed_level.instantiate()
		node_level.call_deferred("add_child",new_level)
		current_level.queue_free()
		current_level=new_level
