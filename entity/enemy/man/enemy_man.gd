extends Enemy

@export var speed_x:float=200

func _physics_process(delta: float) -> void:
	if is_hurted:
		var effect:Node2D=Global.EFFECT_BOOM.instantiate()
		effect.global_position=%MarkerBoom.global_position
		get_parent().add_child(effect)
		Global.play_sfx(Global.SFX_BOOM)
		hp-=1
		if hp<=0:queue_free()
		is_hurted=false
	else:
		velocity.x=direction*speed_x
		velocity.y+=gravity*delta
		move_and_slide()

func _on_hit_box_body_entered(body: Node2D) -> void:
	if hp>0:
		var player:Player=body
		player.is_hurted=true
		player.direction_hurt=direction
