extends Enemy
const SFX_STEP_1 = preload("uid://bi2nfrwhh15th")
const SFX_STEP_2 = preload("uid://l3sn8oe3okv3")
var sfx_steps=[SFX_STEP_1,SFX_STEP_2]

enum State{
	NULL,IDLE,MOVE
}

@export var speed_x:float=300
@export var auto:bool=false

var current_state:State=State.NULL

func _physics_process(delta: float) -> void:
	var next_state=current_state
	match current_state:
		State.NULL:
			if auto:next_state=State.MOVE
			else:next_state=State.IDLE
		State.IDLE:
			if %RayCastTarget.is_colliding():
				print("hitttt")
				next_state=State.MOVE
		State.MOVE:pass
	if next_state==current_state:pass
	else:
		match next_state:
			State.NULL:pass
			State.IDLE:%AnimationPlayer.play("idle",-1,2.0)
			State.MOVE:%AnimationPlayer.play("move",-1,1.1)
		print(current_state,"->",next_state)
		current_state=next_state

	match current_state:
		State.NULL:pass
		State.IDLE:pass
		State.MOVE:
			if is_on_wall():direction*=-1
			if is_on_floor():
				if %RayCast2D.is_colliding():pass
				else:direction*=-1
			velocity.x=direction*speed_x
	
	velocity.y+=gravity*delta
	move_and_slide()

func _on_hurtbox_hit() -> void:die_leave_effect(BOOM)

func play_step() -> void:
	Global.play_sfx2d(sfx_steps.pick_random(),position)
