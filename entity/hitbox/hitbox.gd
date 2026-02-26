extends Area2D

signal hit

func _on_area_entered(hurtbox: Hurtbox) -> void:
	hurtbox.porcess_collision()
	hit.emit()
