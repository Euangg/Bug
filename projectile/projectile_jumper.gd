extends Projectile


#不受重力
#击中玩家消失
#生命周期

func _physics_process(delta: float) -> void:
	position+=velocity*delta

func _on_area_2d_body_entered(player: Player) -> void:
	player.is_hurted=true
	queue_free()


func _on_timer_timeout() -> void:queue_free()
