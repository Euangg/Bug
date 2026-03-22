extends Level

@onready var teleportation: Area2D = $Teleportation

func _ready() -> void:
	Global.fmod_play_bgm("event:/BGM/BGM_3")
