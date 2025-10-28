extends Enemy

enum State{NULL,
	IDLE,MOVE,
	PRE_ATTACK,
	ATTACK,
	HURT,DIE,
}
var current_state:State=State.NULL

signal dead
var input_x:float=0

func _physics_process(delta: float) -> void:
	var player=%DetectiveBox.get_overlapping_bodies()
	if player:%Sprite2D2.modulate=Color(2.521, 0.177, 0.216, 0.675)
	else:%Sprite2D2.modulate=Color.WHITE
	velocity.x=0
	#1/3.状态判断
	var next_state=current_state
	match current_state:
		State.NULL:next_state=State.IDLE
		State.IDLE:
			if %TimerIdle.is_stopped():next_state=State.MOVE
			if player:
				next_state=State.PRE_ATTACK
			if is_hurted:next_state=State.HURT
		State.MOVE:
			if %TimerMove.is_stopped():next_state=State.IDLE
			if is_hurted:next_state=State.HURT
			if player:next_state=State.PRE_ATTACK
		State.HURT:
			if not %AnimationPlayer.is_playing():next_state=State.IDLE
			if hp<=0:
				dead.emit()
				next_state=State.DIE
		State.PRE_ATTACK:
			if not %AnimationPlayer.is_playing():next_state=State.ATTACK
			if is_hurted:next_state=State.HURT
		State.ATTACK:
			if not %AnimationPlayer.is_playing():next_state=State.IDLE
			if is_hurted:next_state=State.HURT
	#2/3.状态切换
	if next_state==current_state:pass
	else:
		match current_state:
			State.ATTACK:
				#%CollisionShape2D.visible=false
				%Laser.visible=false
				Global.play_sfx(Global.SFX_LASER_3)
				%SfxLaser.stop()
		match next_state:
			State.IDLE:
				%AnimationPlayer.play("idle")
				input_x=0
				%TimerIdle.start(randf_range(0.5,3))
			State.MOVE:
				%AnimationPlayer.play("move")
				input_x=randf_range(-1,1)
				if input_x:direction=sign(input_x)
				%TimerMove.start(randf_range(1,5))
			State.HURT:
				%AnimationPlayer.play("hurt")
				hp-=1
				is_hurted=false
				Global.play_sfx(Global.SFX_IMPACT)
			State.DIE:
				%AnimationPlayer.play("die")
				Global.play_sfx(Global.SFX_IMPACT_1)
			State.PRE_ATTACK:%AnimationPlayer.play("pre_attack")
			State.ATTACK:
				%AnimationPlayer.play("attack")
				%CollisionShape2D.visible=true
				Global.play_sfx(Global.SFX_LASER_1)
				%SfxLaser.play()
		current_state=next_state
	#3/3.状态运行
	match current_state:
		State.IDLE:pass
		State.MOVE:
			velocity.x=input_x*400
		State.ATTACK:
			var array:Array=%HitBox.get_overlapping_bodies()
			if array.is_empty():pass
			else:
				array[0].is_hurted=true
				array[0].direction_hurt=direction
		State.HURT:
			velocity.x=1000*direction_hurt
	
	velocity.y+=gravity*delta
	move_and_slide()
