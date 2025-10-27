class_name Level
extends Node2D

var play:Play=null
@onready var enter_point: Node = %EnterPoint
func _ready() -> void:
	play=get_parent().get_parent()
	if play:play.level_switched.emit()

func set_camera_limit():
	if Global.camera:
		Global.camera.limit_left=%LT.position.x
		Global.camera.limit_top=%LT.position.y
		Global.camera.limit_right=%RB.position.x
		Global.camera.limit_bottom=%RB.position.y
