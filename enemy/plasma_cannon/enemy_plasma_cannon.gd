extends Enemy

enum State{NULL,
	IDLE,MOVE,
	PRE_ATTACK,
	ATTACK,
	HURT,DIE,
}
var current_state:State=State.NULL
enum Direction{LEFT=-1,RIGHT=1}
var direction:Direction=Direction.RIGHT:
	set(v):
		direction=v
		if not is_node_ready():await ready
		%Direction.scale.x=direction

var is_hurted:bool=false
var input_x:float=0

func _physics_process(delta: float) -> void:
	var player=%DetectiveBox.get_overlapping_bodies()
	if player:%Sprite2D2.modulate=Color.RED
	else:%Sprite2D2.modulate=Color.WHITE
	
	#1/3.状态判断
	var next_state=current_state
	match current_state:
		State.NULL:next_state=State.IDLE
		State.IDLE:
			if %TimerIdle.is_stopped():next_state=State.MOVE
			if player:
				next_state=State.PRE_ATTACK
			if is_hurted:
				next_state=State.DIE if hp<=0 else State.HURT
		State.MOVE:
			if %TimerMove.is_stopped():next_state=State.IDLE
		State.HURT:
			if not %AnimationPlayer.is_playing():next_state=State.IDLE
			if hp<=0:next_state=State.DIE
		State.PRE_ATTACK:
			if not %AnimationPlayer.is_playing():next_state=State.ATTACK
			if is_hurted:next_state=State.HURT
		State.ATTACK:
			if not %AnimationPlayer.is_playing():next_state=State.IDLE
			if is_hurted:next_state=State.HURT
	#2/3.状态切换
	if next_state==current_state:pass
	else:
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
				is_hurted=false
				%AnimationPlayer.play("hurt")
			State.DIE:%AnimationPlayer.play("die")
			State.PRE_ATTACK:%AnimationPlayer.play("pre_attack")
			State.ATTACK:%AnimationPlayer.play("attack")
		current_state=next_state
	#3/3.状态运行
	match current_state:
		State.IDLE:pass
		State.MOVE:
			velocity.x=input_x*400
	
	velocity.y+=1600*delta
	move_and_slide()


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body is Player:
		hp-=1
		is_hurted=true
