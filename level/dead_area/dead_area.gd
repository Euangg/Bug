extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player:Player=body
		player.timer_end.start()
	if body is Enemy:body.queue_free()
