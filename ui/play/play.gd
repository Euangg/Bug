extends Control

@onready var level_1_2: Node2D = $Level/Level_1_2
func _ready() -> void:
	Global.player=%Player
	Global.camera=%Camera2D
	Global.current_level=level_1_2
	Global.current_level.set_camera_limit()
