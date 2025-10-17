class_name Level
extends Node2D

func _ready() -> void:
	if Global.is_player_entered:
		var mark:Marker2D=%EnterPoint.get_child(Global.enter_point_order)
		if mark: Global.player.position=mark.position
	set_camera_limit()

func set_camera_limit():
	if Global.camera:
		Global.camera.limit_left=%LT.position.x
		Global.camera.limit_top=%LT.position.y
		Global.camera.limit_right=%RB.position.x
		Global.camera.limit_bottom=%RB.position.y
