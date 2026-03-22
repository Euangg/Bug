extends Event

func _on_body_entered(body: Node2D) -> void:
	trigger.emit()
	queue_free()
