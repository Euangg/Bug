extends Enemy

func _on_hurtbox_hitted() -> void:die_leave_effect(BOOM)

func _physics_process(delta: float) -> void:
	velocity.y+=1800*delta
	move_and_slide()
