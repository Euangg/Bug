extends Enemy

@export var speed_x:float=200

func _physics_process(delta: float) -> void:
	if is_on_wall():
		if %TimerDirection.is_stopped():
			velocity.x*=-1
			direction*=-1
			%TimerDirection.start()
		else:pass
	if is_hurted:
		var effect:Node2D=Global.EFFECT_BOOM.instantiate()
		effect.global_position=%MarkerBoom.global_position
		get_parent().add_child(effect)
		Global.play_sfx(Global.SFX_BOOM)
		hp-=1
		if hp<=0:queue_free()
		is_hurted=false
	else:
		if %TimerShoot.is_stopped():
			if %RayCast2D.is_colliding():
				var p:Projectile=Global.PROJECTILE_FLYER.instantiate()
				p.position=%RayCast2D.global_position
				p.velocity=Vector2(0,600)
				%TimerShoot.start()
				add_sibling(p)
		velocity.x=speed_x*direction
		move_and_slide()
