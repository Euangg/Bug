extends Projectile

#不受重力
#击中玩家消失、击中环境消失
#生命周期

func _physics_process(delta: float) -> void:
	position+=velocity*delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		var player:Player=body
		player.is_hurted=true
		if player.current_state==Player.State.SPRINT:pass
		else:queue_free()
	else:queue_free()

func _on_timer_timeout() -> void:queue_free()
