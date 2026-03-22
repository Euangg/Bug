extends Enemy
const LASER = preload("uid://q5awvt2yi17v")
const SFX_LASER_SHOOT = preload("uid://w57ijmkdyn63")

enum State{NULL,IDLE,ATK,
	PRE_SCROLL,
	MOVE
}
var current_state:State=State.NULL

@export var speed_x:float=400

func _physics_process(delta: float) -> void:
	var next_state=current_state
	match current_state:
		State.NULL:next_state=State.IDLE
		State.IDLE:
			if %RayCastDetect.is_colliding():next_state=State.ATK
		State.ATK:
			if %AnimationPlayer.is_playing():pass
			else:next_state=State.PRE_SCROLL
		State.PRE_SCROLL:
			if not %AnimationPlayer.is_playing():next_state=State.MOVE
		State.MOVE:pass
	#2/3.状态切换
	if next_state==current_state:pass
	else:
		match current_state:
			State.IDLE:pass
		match next_state:
			State.IDLE:
				%AnimationPlayer.play("idle")
				velocity.x=0
			State.ATK:%AnimationPlayer.play("atk")
			State.PRE_SCROLL:
				%AnimationPlayer.play("pre_scroll")
				Global.play_sfx(Global.SFX_BALL_TRANSFORM)
			State.MOVE:
				%AnimationPlayer.play("move")
				%AudioStreamPlayer.play()
	current_state=next_state
	#3/3.状态运行
	match current_state:
		State.IDLE:
			if %TimerLookback.is_stopped():
				%TimerLookback.start()
				direction*=-1
		State.MOVE:
			velocity.x=direction*speed_x
	
	velocity.y+=gravity*delta
	move_and_slide()

func shoot_ammo():
	var p:Projectile=LASER.instantiate()
	p.position=%MarkerFire.global_position
	p.scale.x=direction
	add_sibling(p)
	Global.play_sfx2d(SFX_LASER_SHOOT,position)

func _on_hurtbox_hit() -> void:
	die_leave_effect(BOOM)
