extends Enemy
const SFX_STEP_1 = preload("uid://bi2nfrwhh15th")
const SFX_STEP_2 = preload("uid://l3sn8oe3okv3")
var sfx_steps=[SFX_STEP_1,SFX_STEP_2]

@export var speed_x:float=200

func _physics_process(delta: float) -> void:
	velocity.x=direction*speed_x
	velocity.y+=gravity*delta
	move_and_slide()
	
	if is_on_wall():direction*=-1
	if is_on_floor():
		if %RayCast2D.is_colliding():pass
		else:direction*=-1

func _on_hurtbox_hit() -> void:die_leave_effect(Enemy.BOOM)

func play_step() -> void:
	Global.play_sfx2d(sfx_steps.pick_random(),position)
