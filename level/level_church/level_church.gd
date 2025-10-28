extends Level


func _ready():
	super._ready()
	Global.play_bgm(Global.BGM_FLAT)


func _on_area_2d_body_entered(body: Node2D) -> void:
	var tween:Tween=create_tween()
	tween.tween_property(Global.camera,"zoom",Vector2(0.4,0.4),0.5)


func _on_enemy_noah_dead() -> void:
	%TimerEnd.start()


func _on_timer_end_timeout() -> void:Global.switch_scene(Global.UI_CLEAR)
