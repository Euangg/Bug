extends CharacterBody2D

enum State{IDLE,RUN,
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
	
	#1/3.状态判断
	var next_state=current_state
	match current_state:
		State.IDLE:
			if is_zero_approx(input_x):pass
			else:next_state=State.RUN
			if velocity.y>0:next_state=State.FALL
			if velocity.y<0:next_state=State.RISE
		State.RUN:
			if is_zero_approx(input_x):next_state=State.IDLE
			if velocity.y>0:next_state=State.FALL
			if velocity.y<0:next_state=State.RISE
		State.RISE:
			if velocity.y>0:next_state=State.FALL
			if is_on_floor():next_state=State.IDLE
		State.FALL:
			if velocity.y<0:next_state=State.RISE
			if is_on_floor():next_state=State.IDLE
	#2/3.状态切换
	if next_state==current_state:pass
	else:
		match next_state:
			State.IDLE:%AnimationPlayer.play("idle")
			State.RUN:%AnimationPlayer.play("run")
			State.RISE:%AnimationPlayer.play("rise")
			State.FALL:%AnimationPlayer.play("fall")
		current_state=next_state
	#3/3.状态运行
	match current_state:
		State.IDLE:
			if Input.is_action_just_pressed("space"):velocity.y=-1000
		State.RUN:
			if Input.is_action_just_pressed("space"):velocity.y=-1000
		State.RISE:pass
		State.FALL:pass
	
	velocity.x=450*input_x
	velocity.y+=1600*delta
	move_and_slide()
