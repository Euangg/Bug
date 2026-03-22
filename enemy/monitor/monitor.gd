extends Enemy

const AMMO = preload("uid://cf856cjiq4nq7")
const SFX_FIRE = preload("uid://blb5iw04gpdc6")


var target:Node2D=null
func _physics_process(delta: float) -> void:
	if target:
		var dir:Vector2=target.global_position-%head.global_position
		%head.rotation=dir.angle()*direction
		if direction==Direction.LEFT:%head.rotation+=PI
		if %Timer.is_stopped():
			var p:Projectile=AMMO.instantiate()
			p.position=%MarkerFire.global_position
			p.velocity=dir.normalized()*900
			p.rotation=p.velocity.angle()
			add_sibling(p)
			Global.play_sfx2d(SFX_FIRE,position)
			%Timer.start()
	else:
		%head.rotation+=delta
		if %RayCastDetect.is_colliding():
			var p:Player=%RayCastDetect.get_collider()
			target=p.marker_enemy_target
			%Timer.start()
		

func _on_hurtbox_hit() -> void:die_leave_effect(BOOM)
