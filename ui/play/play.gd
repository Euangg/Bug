extends Control

@onready var level_1: Node2D = $Level/Level1
func _ready() -> void:
	Global.player=%Player
	Global.camera=%Camera2D
	Global.current_level=level_1
	Global.current_level.set_camera_limit()
