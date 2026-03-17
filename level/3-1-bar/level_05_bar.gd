extends Level

@onready var teleportation: Area2D = $Teleportation

func _ready() -> void:
	Global.fmod_play_bgm("event:/BGM/BGM_3")

func _on_timer_timeout() -> void:
	teleportation.monitoring=true
