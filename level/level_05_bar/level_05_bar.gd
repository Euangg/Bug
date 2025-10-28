extends Level


@onready var teleportation: Area2D = $Teleportation
func _on_timer_timeout() -> void:
	teleportation.monitoring=true
