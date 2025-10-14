extends CharacterBody2D

enum State{IDLE,RUN,
	PRE_JUMP,
	RISE,FALL,
	ATTACK,
	HURT,DIE,
}
var current_state:State=State.IDLE

enum Direction{LEFT=-1,RIGHT=1}
var direction:Direction=Direction.RIGHT:
	set(v):
		direction=v
		if not is_node_ready():await ready
		%Direction.scale.x=direction

func _physics_process(delta: float) -> void:
	var input_x=Input.get_axis("a","d")
	if not is_zero_approx(input_x):
		direction=Direction.LEFT if input_x<0 else Direction.RIGHT
	var is_jump_pressed=Input.is_action_just_pressed("space")
	var is_atk_pressed=Input.is_action_just_pressed("j")
	
	#1/3.状态判断
	var next_state=current_state
	match current_state:
		State.IDLE:
			if is_zero_approx(input_x):pass
			else:next_state=State.RUN
			if velocity.y>0:next_state=State.FALL
			if velocity.y<0:next_state=State.RISE
			if is_atk_pressed:next_state=State.HURT
			if is_jump_pressed:next_state=State.PRE_JUMP
		State.RUN:
			if is_zero_approx(input_x):next_state=State.IDLE
			if velocity.y>0:next_state=State.FALL
			if velocity.y<0:next_state=State.RISE
			if is_atk_pressed:next_state=State.HURT
			if is_jump_pressed:next_state=State.PRE_JUMP
		State.PRE_JUMP:
			if velocity.y<0:next_state=State.RISE
		State.RISE:
			if velocity.y>0:next_state=State.FALL
			if is_on_floor():next_state=State.IDLE
			if is_atk_pressed:next_state=State.HURT
		State.FALL:
			if velocity.y<0:next_state=State.RISE
			if is_on_floor():next_state=State.IDLE
			if is_atk_pressed:next_state=State.HURT
		State.HURT:
			if not %AnimationPlayer.is_playing():next_state=State.IDLE
	#2/3.状态切换
	if next_state==current_state:pass
	else:
		match next_state:
			State.IDLE:%AnimationPlayer.play("idle")
			State.RUN:%AnimationPlayer.play("run")
			State.PRE_JUMP:
				%AnimationPlayer.play("pre_jump")
				velocity.x=0
			State.RISE:%AnimationPlayer.play("rise")
			State.FALL:%AnimationPlayer.play("fall")
			State.HURT:
				%AnimationPlayer.play("hurt")
				velocity.x=0
		current_state=next_state
	#3/3.状态运行
	match current_state:
		State.IDLE:
			velocity.x=450*input_x
		State.RUN:
			velocity.x=450*input_x
		State.PRE_JUMP:
			if not %AnimationPlayer.is_playing():velocity.y=-1000
		State.RISE:velocity.x=450*input_x
		State.FALL:velocity.x=450*input_x
		State.HURT:pass
	
	velocity.y+=1600*delta
	move_and_slide()
