class_name Player
extends CharacterBody2D

enum State{IDLE,RUN,
	PRE_JUMP,
	RISE,FALL,
	SPRINT,
	ATK_COMMON,
	ATK_TILT,
	HURT,DIE,
}
var current_state:State=State.IDLE

enum Direction{LEFT=-1,RIGHT=1}
var direction:Direction=Direction.RIGHT:
	set(v):
		direction=v
		if not is_node_ready():await ready
		%Direction.scale.x=direction

var is_sprint_hit_enemy:bool
var is_hurted:bool=false
var time_sprint_held:float
func _physics_process(delta: float) -> void:
	var input_x=Input.get_axis("a","d")
	var is_jump_pressed=Input.is_action_just_pressed("space")
	var is_attack_pressed=Input.is_action_just_pressed("j")
	var is_sprint_held=Input.is_action_pressed("l")
	var is_sprint_released=Input.is_action_just_released("l")
	velocity.x=0
	#1/3.状态判断
	var next_state=current_state
	match current_state:
		State.IDLE:
			if is_zero_approx(input_x):pass
			else:next_state=State.RUN
			if velocity.y>0:next_state=State.FALL
			if velocity.y<0:next_state=State.RISE
			if is_attack_pressed:next_state=State.ATK_COMMON
			if is_jump_pressed:next_state=State.PRE_JUMP
			if is_sprint_released:next_state=State.SPRINT
			if is_hurted:next_state=State.HURT
		State.RUN:
			if is_zero_approx(input_x):next_state=State.IDLE
			if velocity.y>0:next_state=State.FALL
			if velocity.y<0:next_state=State.RISE
			if is_attack_pressed:next_state=State.ATK_COMMON
			if is_jump_pressed:next_state=State.PRE_JUMP
			if is_sprint_released:next_state=State.SPRINT
			if is_hurted:next_state=State.HURT
		State.PRE_JUMP:
			if velocity.y<0:next_state=State.RISE
			if is_hurted:next_state=State.HURT
		State.RISE:
			if velocity.y>0:next_state=State.FALL
			if is_on_floor():next_state=State.IDLE
			if is_attack_pressed:next_state=State.ATK_COMMON
			if is_sprint_released:next_state=State.SPRINT
			if is_hurted:next_state=State.HURT
		State.FALL:
			if velocity.y<0:next_state=State.RISE
			if is_on_floor():next_state=State.IDLE
			if is_attack_pressed:next_state=State.ATK_COMMON
			if is_sprint_released:next_state=State.SPRINT
			if is_hurted:next_state=State.HURT
		State.SPRINT:
			if %TimerSprint.is_stopped():next_state=State.IDLE
			if is_sprint_hit_enemy:next_state=State.ATK_TILT
		State.HURT:
			if not %AnimationPlayer.is_playing():next_state=State.IDLE
		State.ATK_COMMON:
			if not %AnimationPlayer.is_playing():next_state=State.IDLE
		State.ATK_TILT:
			if not %AnimationPlayer.is_playing():next_state=State.IDLE
	#2/3.状态切换
	if next_state==current_state:pass
	else:
		match next_state:
			State.IDLE:%AnimationPlayer.play("idle")
			State.RUN:%AnimationPlayer.play("run")
			State.PRE_JUMP:%AnimationPlayer.play("pre_jump")
			State.RISE:%AnimationPlayer.play("rise")
			State.FALL:%AnimationPlayer.play("fall")
			State.SPRINT:
				%AnimationPlayer.play("sprint")
				is_sprint_hit_enemy=false
				if time_sprint_held>=0.5:
					%TimerSprint.start(0.3)
					Global.play_sfx(Global.SFX_IMPACT_1)
				else:
					%TimerSprint.start(0.1)
					Global.play_sfx(Global.SFX_IMPACT)
				time_sprint_held=0
			State.HURT:
				%AnimationPlayer.play("hurt")
				is_hurted=false
				time_sprint_held=0
				Global.play_sfx(Global.SFX_IMPACT_1)
			State.ATK_COMMON:%AnimationPlayer.play("atk_common")
			State.ATK_TILT:%AnimationPlayer.play("atk_tilt")
		current_state=next_state
	#3/3.状态运行
	match current_state:
		State.IDLE:
			velocity.x=450*input_x
			if not is_zero_approx(input_x):
				direction=Direction.LEFT if input_x<0 else Direction.RIGHT
			if is_sprint_held:time_sprint_held+=delta
		State.RUN:
			velocity.x=450*input_x
			if not is_zero_approx(input_x):
				direction=Direction.LEFT if input_x<0 else Direction.RIGHT
			if is_sprint_held:time_sprint_held+=delta
		State.PRE_JUMP:
			if not %AnimationPlayer.is_playing():velocity.y=-1000
			if not is_zero_approx(input_x):
				direction=Direction.LEFT if input_x<0 else Direction.RIGHT
		State.RISE:
			velocity.x=450*input_x
			if not is_zero_approx(input_x):
				direction=Direction.LEFT if input_x<0 else Direction.RIGHT
		State.FALL:
			velocity.x=450*input_x
			if not is_zero_approx(input_x):
				direction=Direction.LEFT if input_x<0 else Direction.RIGHT
		State.SPRINT:
			if %HitBoxSprint.has_overlapping_bodies():is_sprint_hit_enemy=true
			is_hurted=false
			velocity.x=1500*direction
		State.HURT:
			is_hurted=false
		State.ATK_COMMON:pass
	
	velocity.y+=3000*delta
	move_and_slide()
