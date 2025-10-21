class_name Player
extends Entity
enum State{IDLE,RUN,
	PRE_JUMP,
	RISE,FALL,
	SPRINT,
	ATK_COMMON,
	ATK_TILT,
	HURT,DIE,
}
var current_state:State=State.IDLE

var is_sprint_hit_enemy:bool
var time_sprint_held:float

@onready var timer_end: Timer = $TimerEnd
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
			if is_on_floor():
				next_state=State.IDLE
				Global.play_sfx(Global.SFX_DROP)
			if is_attack_pressed:next_state=State.ATK_COMMON
			if is_sprint_released:next_state=State.SPRINT
			if is_hurted:next_state=State.HURT
		State.SPRINT:
			if %TimerSprint.is_stopped():next_state=State.IDLE
			if is_sprint_hit_enemy:next_state=State.ATK_TILT
		State.HURT:
			if not %AnimationPlayer.is_playing():
				next_state=State.IDLE
				if hp<=0:next_state=State.DIE
		State.ATK_COMMON:
			if not %AnimationPlayer.is_playing():next_state=State.IDLE
		State.ATK_TILT:
			if not %AnimationPlayer.is_playing():next_state=State.IDLE
		State.DIE:pass
	#2/3.状态切换
	if next_state==current_state:pass
	else:
		match current_state:
			State.RUN:%TimerStep.stop()
			State.ATK_COMMON:
				if %HitBox.is_connected("body_entered",atk_effect):
					%HitBox.disconnect("body_entered",atk_effect)
		match next_state:
			State.IDLE:%AnimationPlayer.play("idle")
			State.RUN:
				%AnimationPlayer.play("run")
				%TimerStep.start()
			State.PRE_JUMP:%AnimationPlayer.play("pre_jump")
			State.RISE:%AnimationPlayer.play("rise")
			State.FALL:%AnimationPlayer.play("fall")
			State.SPRINT:
				%AnimationPlayer.play("sprint")
				Global.play_sfx(Global.SFX_SPRINT)
				is_sprint_hit_enemy=false
				if time_sprint_held>=0.5:%TimerSprint.start(0.3)
				else:%TimerSprint.start(0.1)
				time_sprint_held=0
			State.HURT:
				%AnimationPlayer.play("hurt")
				Global.play_sfx(Global.SFX_HURT)
				hp-=1
				is_hurted=false
				time_sprint_held=0
			State.ATK_COMMON:
				%AnimationPlayer.play("atk_common")
				%HitBox.connect("body_entered",atk_effect)
				Global.play_sfx(Global.SFX_ATTACK)
			State.ATK_TILT:%AnimationPlayer.play("atk_tilt")
			State.DIE:
				%AnimationPlayer.play("die")
				Global.play_sfx(Global.SFX_DEATH)
				%TimerEnd.start()
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
			if not %AnimationPlayer.is_playing():
				velocity.y=-1900
				Global.play_sfx(Global.SFX_JUMP)
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
			#if %HitBoxSprint.has_overlapping_bodies():is_sprint_hit_enemy=true
			is_hurted=false
			velocity.x=1500*direction
		State.HURT:
			is_hurted=false
			velocity.x=1000*direction_hurt
		State.ATK_COMMON:
			pass
	
	velocity.y+=gravity*delta
	move_and_slide()

func atk_effect(enemy:Enemy):
	enemy.is_hurted=true
	enemy.direction_hurt=direction
	Global.play_sfx(Global.SFX_HIT)


func _on_timer_end_timeout() -> void:
	Global.switch_scene(Global.UI_FAIL)

var sfx_steps=[Global.SFX_STEP_1,Global.SFX_STEP_2,Global.SFX_STEP_3]
func _on_timer_step_timeout() -> void:
	Global.play_sfx(sfx_steps.pick_random())
