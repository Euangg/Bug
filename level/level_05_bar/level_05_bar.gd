extends Level


@onready var teleportation: Area2D = $Teleportation

func _ready() -> void:
	Global.play_bgm(Global.BGM_TOWN)

func _on_timer_timeout() -> void:
	teleportation.monitoring=true
