extends Enemy

@export var speed_x:float=200

func _physics_process(delta: float) -> void:
	if is_hurted:
		var effect:Node2D=Global.EFFECT_BOOM.instantiate()
		effect.global_position=%MarkerBoom.global_position
		get_parent().add_child(effect)
		queue_free()
	
	velocity.x=speed_x*direction
	move_and_slide()


func _on_hit_box_body_entered(body: Node2D) -> void:
	var player:Player=body
	player.is_hurted=true
	player.direction_hurt=direction
