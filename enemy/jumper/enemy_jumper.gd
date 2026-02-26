extends Enemy

enum State{NULL,IDLE,
	PRE_JUMP,
	RISE,FALL,
}
var current_state:State=State.NULL

var is_player_detected:bool=false
func _physics_process(delta: float) -> void:
	#1/3.状态判断
	var next_state=current_state
	match current_state:
		State.NULL:next_state=State.IDLE
		State.IDLE:
			if %TimerIdle.is_stopped():
				if is_player_detected:next_state=State.PRE_JUMP
		State.PRE_JUMP:
			if velocity.y<0:next_state=State.RISE
		State.RISE:
			if velocity.y>0:next_state=State.FALL
		State.FALL:
			if is_on_floor():
				next_state=State.IDLE
				Global.play_sfx(Global.SFX_JUMPER_LAND)
	#2/3.状态切换
	if next_state==current_state:pass
	else:
		match current_state:
			State.IDLE:pass
		match next_state:
			State.IDLE:
				%AnimationPlayer.play("idle")
				%TimerIdle.start()
				velocity.x=0
			State.PRE_JUMP:%AnimationPlayer.play("pre_jump")
			State.RISE:%AnimationPlayer.play("rise")
			State.FALL:
				%AnimationPlayer.play("fall")
				if current_state==State.RISE:
					var p:Projectile=Global.PROJECTILE_1.instantiate()
					p.position=position
					p.velocity=position.direction_to(Global.player.position)*1000
					p.rotation=p.velocity.angle()
					get_parent().add_child(p)
					Global.play_sfx(Global.SFX_JUMPER_FIRE)
	current_state=next_state
	#3/3.状态运行
	match current_state:
		State.IDLE:pass
		State.PRE_JUMP:
			if not %AnimationPlayer.is_playing():
				velocity.y-=2500
				velocity.x=500*sign(Global.player.position.x-position.x)
				if velocity.x>0:direction=Direction.RIGHT
				if velocity.x<0:direction=Direction.LEFT
				Global.play_sfx(Global.SFX_JUMPER_JUMP)
	
	if is_hurted:
		is_hurted=false
		hp-=1
		if hp<=0:die_boom()
	velocity.y+=gravity*delta
	move_and_slide()


func _on_area_detective_body_entered(body: Node2D) -> void:
	is_player_detected=true
