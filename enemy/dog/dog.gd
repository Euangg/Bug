extends Enemy

enum State{
	NULL,IDLE,RUN,
	READY_RUN,READY_IDLE,
	JUMP,ATK
}

var current_state:State=State.NULL
func _physics_process(delta: float) -> void:
	var input_x=Input.get_axis("a","d")
	
	
	var next_state=current_state
	match current_state:
		State.NULL:next_state=State.IDLE
		State.IDLE:
			if is_zero_approx(input_x):pass
			else:next_state=State.READY_RUN
		State.READY_RUN:
			if %AnimationPlayer.is_playing():
				if is_zero_approx(input_x):next_state=State.IDLE
			else:next_state=State.RUN
		State.RUN:
			if is_zero_approx(input_x):next_state=State.READY_IDLE
		State.READY_IDLE:
			if %AnimationPlayer.is_playing():
				if is_zero_approx(input_x):pass
				else:next_state=State.RUN
			else:next_state=State.IDLE
	
	if next_state==current_state:pass
	else:
		match next_state:
			State.IDLE:%AnimationPlayer.play("idle")
			State.READY_RUN:%AnimationPlayer.play("ready",-1,2)
			State.READY_IDLE:%AnimationPlayer.play("ready",-1,-2,true)
			State.RUN:%AnimationPlayer.play("run")
		current_state=next_state
		
	match current_state:
		State.IDLE:pass
		
	if is_zero_approx(input_x):pass
	else:direction=sign(input_x)
	velocity.x=900*input_x
	velocity.y+=900*delta
	move_and_slide()
	
