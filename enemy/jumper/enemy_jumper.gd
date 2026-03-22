class_name EnemySpider
extends Enemy
const SFX_FIRE = preload("uid://blb5iw04gpdc6")
const SFX_JUMP = preload("uid://chkxrg0ivxjfr")
const SFX_LAND = preload("uid://5ti72dmkyxno")
const AMMO = preload("uid://h2wvm8kf2mgb")
const DUST = preload("uid://ese3t2l4wxnv")

enum State{NULL,IDLE,
	PRE_JUMP,RISE,FALL,
}
var current_state:State=State.NULL
var has_spawn_dust=false
var fire_cycle=1
var target:Player=null
func _ready() -> void:
	gravity=3000

func _physics_process(delta: float) -> void:
	#1/3.状态判断
	var next_state=current_state
	match current_state:
		State.NULL:next_state=State.IDLE
		State.IDLE:
			if %TimerIdle.is_stopped():
				if target:next_state=State.PRE_JUMP
			if velocity.y>0:next_state=State.FALL
		State.PRE_JUMP:
			if velocity.y<0:next_state=State.RISE
		State.RISE:
			if velocity.y>0:next_state=State.FALL
		State.FALL:
			if is_on_floor():
				next_state=State.IDLE
				Global.play_sfx2d(SFX_LAND,position)
	#2/3.状态切换
	if next_state==current_state:pass
	else:
		match current_state:
			State.FALL:
				if has_spawn_dust:
					has_spawn_dust=false
					var dust=DUST.instantiate()
					dust.position=position
					add_sibling(dust)
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
					var p:Projectile=AMMO.instantiate()
					p.position=position
					
					if fire_cycle:
						p.velocity=position.direction_to(Global.player.position)*800
					else:
						p.scale=Vector2(2,2)
						p.modulate=Color(0x00ff00ff)
						p.velocity=position.direction_to(Global.player.position)*500
					p.rotation=p.velocity.angle()
					add_sibling(p)
					Global.play_sfx2d(SFX_FIRE,position)
					fire_cycle+=1
					fire_cycle%=3
	current_state=next_state
	#3/3.状态运行
	match current_state:
		State.IDLE:pass
		State.PRE_JUMP:
			if not %AnimationPlayer.is_playing():
				velocity.y-=2000
				velocity.x=500*sign(target.position.x-position.x)
				if velocity.x>0:direction=Direction.RIGHT
				if velocity.x<0:direction=Direction.LEFT
				Global.play_sfx2d(SFX_JUMP,position)
	
	velocity.y+=gravity*delta
	move_and_slide()

func _on_hurtbox_hit() -> void:
	hp-=1
	if hp<=0:die_leave_effect(BOOM_BIG)
	else:stun()
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

	
