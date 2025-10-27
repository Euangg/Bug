extends Enemy

enum State{NULL,IDLE,
	PRE_ATTACK,
	MOVE
}
var current_state:State=State.NULL

var is_player_detected:bool=false
@export var speed_x:float=200

func _physics_process(delta: float) -> void:
	#1/3.状态判断
	var next_state=current_state
	match current_state:
		State.NULL:next_state=State.IDLE
		State.IDLE:
			if is_player_detected:next_state=State.PRE_ATTACK
		State.PRE_ATTACK:
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
			State.PRE_ATTACK:%AnimationPlayer.play("pre_attack")
			State.MOVE:%AnimationPlayer.play("move")
	current_state=next_state
	#3/3.状态运行
	match current_state:
		State.IDLE:
			if %TimerLookback.is_stopped():
				%TimerLookback.start()
				direction*=-1
		State.MOVE:
			velocity.x=direction*speed_x
	
	if is_hurted:
		var effect:Node2D=Global.EFFECT_BOOM.instantiate()
		effect.global_position=%MarkerBoom.global_position
		get_parent().add_child(effect)
		Global.play_sfx(Global.SFX_BOOM)
		hp-=1
		if hp<=0:queue_free()
		is_hurted=false
	else:
		velocity.y+=gravity*delta
		move_and_slide()
	


func _on_hit_box_body_entered(body: Node2D) -> void:
	if hp>0:
		var player:Player=body
		player.is_hurted=true
		player.direction_hurt=direction


func _on_area_detective_body_entered(body: Node2D) -> void:
	is_player_detected=true
