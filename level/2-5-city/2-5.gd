extends Level


func _on_enemy_shield_dead() -> void:
	%TimerEnd.start()


func _on_timer_end_timeout() -> void:
	Global.switch_scene(Global.UI_CG3)
