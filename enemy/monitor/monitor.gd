extends Enemy

const AMMO = preload("uid://cf856cjiq4nq7")
const SFX_FIRE = preload("uid://blb5iw04gpdc6")

func _physics_process(delta: float) -> void:
	var dir:Vector2=get_global_mouse_position()-%head.global_position
	%head.rotation=dir.angle()
	
	if Input.is_action_just_pressed("mouse_left"):
		var p:Projectile=AMMO.instantiate()
		p.position=%MarkerFire.global_position
		p.velocity=dir.normalized()*900
		p.rotation=p.velocity.angle()
		add_sibling(p)
		Global.play_sfx2d(SFX_FIRE,position)
