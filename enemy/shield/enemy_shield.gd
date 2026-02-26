extends Enemy

enum State{NULL,
	IDLE,MOVE,
	PRE_ATTACK,
	HURT,DIE,
}
var current_state:State=State.NULL



var timer_ghost:float=0
func _process(delta: float) -> void:
	if current_state==State.MOVE:
		if timer_ghost<=0:
			var ghost=Sprite2D.new()
			ghost.texture=%Sprite2D.texture
			ghost.hframes=%Sprite2D.hframes
			ghost.vframes=%Sprite2D.vframes
			ghost.frame=%Sprite2D.frame
			ghost.global_position=%Sprite2D.global_position
			ghost.flip_h=true if direction==Direction.RIGHT else false
			ghost.modulate=Color(1,0,0,0.4)
			add_sibling(ghost)
			timer_ghost=0.08
			create_tween().tween_property(ghost,"modulate:a",0.0,1).set_ease(Tween.EASE_OUT)
			create_tween().tween_callback(ghost.queue_free).set_delay(1)
		else:timer_ghost-=delta

var hurt_time:int=0
var input_x:float=0
func _physics_process(delta: float) -> void:
	#1/3.状态判断
	var next_state=current_state
	match current_state:
		State.NULL:next_state=State.IDLE
		State.IDLE:
			if %AreaDetective.has_overlapping_bodies():next_state=State.PRE_ATTACK
			if is_hurted:next_state=State.HURT
		State.PRE_ATTACK:
			if not %AnimationPlayer.is_playing():next_state=State.MOVE
			if hp<=0:next_state=State.DIE
		State.MOVE:
			if %TimerMove.is_stopped():next_state=State.IDLE
			if hp<=0:next_state=State.DIE
		State.HURT:
			if not %AnimationPlayer.is_playing():
				if hp<=0:next_state=State.DIE
				else:next_state=State.IDLE
	#2/3.状态切换
	if next_state==current_state:pass
	else:
		match current_state:
			State.MOVE:
				%HitBox.monitoring=false
		match next_state:
			State.IDLE:%AnimationPlayer.play("idle")
			State.PRE_ATTACK:
				%AnimationPlayer.play("pre_attack")
				velocity.x=0
			State.MOVE:
				%AnimationPlayer.play("move")
				%HitBox.monitoring=true
				velocity.x=1200*direction
				%TimerMove.start()
			State.HURT:
				%AnimationPlayer.play("hurt")
				velocity.x=0
			State.DIE:
				%AnimationPlayer.play("die")
				velocity.x=0
		current_state=next_state
	#3/3.状态运行
	match current_state:
		State.IDLE:
			if %TimerIdleMove.is_stopped():
				%TimerIdleMove.start()
				input_x=randf_range(-1,1)
				if input_x:direction=sign(input_x)
			velocity.x=input_x*300	
		State.PRE_ATTACK:
			if is_hurted:hp-=1
			is_hurted=false
		State.MOVE:
			if is_hurted:hp-=1
			is_hurted=false
		State.HURT:
			if is_hurted:hp-=1
			is_hurted=false
		
	velocity.y+=gravity*delta
	move_and_slide()
