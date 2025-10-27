extends Enemy
enum State{NULL,IDLE,
	MOVE,ATTACK,
}
var current_state:State=State.NULL
var is_player_detected:bool=false
var input_x:float
func _physics_process(delta: float) -> void:
	#1/3.状态判断
	var next_state=current_state
	match current_state:
		State.NULL:next_state=State.IDLE
		State.IDLE:
			if %TimerIdle.is_stopped():next_state=State.MOVE
			if is_player_detected:next_state=State.ATTACK
		State.MOVE:
			if %TimerMove.is_stopped():next_state=State.IDLE
			if is_player_detected:next_state=State.ATTACK
		State.ATTACK:
			if not %AnimationPlayer.is_playing():
				next_state=State.IDLE
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
			State.MOVE:
				%AnimationPlayer.play("move")
				input_x=[-1,1].pick_random()
				direction=sign(input_x)
				%TimerMove.start()
			State.ATTACK:
				%AnimationPlayer.play("attack")
				velocity.x=0
	current_state=next_state
	#3/3.状态运行
	match current_state:
		State.IDLE:pass
		State.MOVE:
			velocity.x=input_x*200
		State.ATTACK:
			var dx=Global.player.position.x-position.x
			if is_zero_approx(dx):pass
			else:direction=sign(dx)
	
	if is_hurted:
		is_hurted=false
		hp-=1
		if hp<=0:die_boom()
	velocity.y+=gravity*delta
	move_and_slide()

func thorw_box():
	var p:Projectile=Global.PROJECTILE_THROWER.instantiate()
	p.position=%MarkerBox.global_position
	var dx=Global.player.position.x-p.position.x
	var dy=Global.player.position.y-p.position.y
	if is_zero_approx(dx):
		p.velocity=Vector2(0,-600)
	else:
		p.velocity.x=1200*sign(dx)
		var t=dx/p.velocity.x
		p.velocity.y=dy/t-0.5*Entity.gravity*t
	get_parent().add_child(p)

func _on_area_detection_body_entered(body: Node2D) -> void:
	is_player_detected=true


func _on_area_detection_body_exited(body: Node2D) -> void:
	is_player_detected=false
