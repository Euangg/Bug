extends Enemy

func _physics_process(delta: float) -> void:
	velocity.y+=gravity*delta
	move_and_slide()
