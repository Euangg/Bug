extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player:Player=body
		player.hp=0
		player.dead.emit()
		Global.play_sfx(Global.SFX_DEATH)
	if body is Enemy:body.queue_free()
