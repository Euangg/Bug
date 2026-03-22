extends Enemy
const LASER = preload("uid://q5awvt2yi17v")
const SFX_LASER_SHOOT = preload("uid://w57ijmkdyn63")

enum State{NULL,IDLE,
	PRE_SMASH,SMASH,ATK,
	HURT,DIE,
}
var current_state:State=State.NULL

var timer_ghost:float=0
func _process(delta: float) -> void:
	if current_state==State.SMASH:
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

var smash_hit_wall_times:int=0
func _physics_process(delta: float) -> void:
	#1/3.状态判断
	var next_state=current_state
	match current_state:
		State.NULL:next_state=State.IDLE
		State.IDLE:
			if %DetectBox.has_overlapping_bodies():next_state=State.PRE_SMASH
		State.PRE_SMASH:
			if not %AnimationPlayer.is_playing():next_state=State.SMASH
		State.SMASH:
			if smash_hit_wall_times:
				if %DetectBox.has_overlapping_bodies():next_state=State.ATK
				if smash_hit_wall_times>=2:next_state=State.ATK
		State.ATK:
			if not %AnimationPlayer.is_playing():next_state=State.IDLE
		State.HURT:
			if not %AnimationPlayer.is_playing():next_state=State.IDLE
		State.DIE:pass
	#强制
	if hp<=0:next_state=State.DIE
	#2/3.状态切换
	if next_state==current_state:pass
	else:
		match current_state:
			State.SMASH:pass
		match next_state:
			State.IDLE:%AnimationPlayer.play("idle")
			State.PRE_SMASH:
				%AnimationPlayer.play("pre_smash")
			State.SMASH:
				%AnimationPlayer.play("smash")
				smash_hit_wall_times=0
			State.ATK:
				%AnimationPlayer.play("atk")
				velocity.x=0
			State.HURT:
				if %DetectBox.has_overlapping_bodies():pass
				else:direction*=-1
				%AnimationPlayer.play("hurt")
				velocity.x=0
			State.DIE:
				%AnimationPlayer.play("die")
				velocity.x=0
		current_state=next_state
	#3/3.状态运行
	match current_state:
		State.IDLE:
			if is_on_wall():direction*=-1
			velocity.x=direction*200	
		State.PRE_SMASH:
			velocity.x=0
		State.SMASH:
			if is_on_wall():
				direction*=-1
				smash_hit_wall_times+=1
			velocity.x=1000*direction
		State.ATK:pass
		
	velocity.y+=gravity*delta
	move_and_slide()

func _on_hurtbox_hit() -> void:
	hp-=1
	if hp<=0:
		%Hurtbox.set_deferred("monitorable",false)
		%Hitbox.set_deferred("monitoring",false)
	else:
		if %DetectBox2.has_overlapping_bodies():pass
		else:direction*=-1
		stun()
func stun():
	process_mode=Node.PROCESS_MODE_DISABLED
	modulate=Color(0xff00ffff)
	%Hurtbox.set_deferred("monitorable",false)
	%Hitbox.set_deferred("monitoring",false)
	%TimerStun.start()
func _on_timer_stun_timeout() -> void:
	process_mode=Node.PROCESS_MODE_INHERIT
	modulate=Color(0xffffffff)
	%Hurtbox.set_deferred("monitorable",true)
	%Hitbox.set_deferred("monitoring",true)

func shoot_ammo():
	var p:Projectile=LASER.instantiate()
	p.position=%MarkerFire.global_position
	p.scale.y=2
	p.scale.x=direction
	add_sibling(p)
	Global.play_sfx2d(SFX_LASER_SHOOT,position)

func die_and_boom():
	var bp=%Booms.get_children()
	for b in bp:
		var effect:Node2D=BOOM_BIG.instantiate()
		effect.position=b.global_position
		add_sibling(effect)
	dead.emit()
	queue_free()
