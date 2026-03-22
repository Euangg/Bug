extends Enemy

@export var speed:float=200

var target:Node2D=null
var chase_x=true
func _physics_process(delta: float) -> void:
	velocity=Vector2.ZERO
	if target:
		direction=sign(target.global_position.x-position.x)
		if chase_x:
			if abs(position.x-target.global_position.x)<5:chase_x=false
		else:
			if abs(position.y-target.global_position.y)<5:chase_x=true
		
		var dir=position.direction_to(target.global_position)
		var dis=position.distance_to(target.global_position)
		if dis>300:
			velocity=speed*dir
		else:
			if chase_x:
				velocity.x=speed*sign(dir.x)
			else:
				velocity.y=speed*sign(dir.y)
	else:pass
	
	move_and_slide()

func _on_hurtbox_hit() -> void:die_leave_effect(BOOM)


func _on_area_2d_body_entered(body: Player) -> void:
	if target:return
	target=body.marker_enemy_target
