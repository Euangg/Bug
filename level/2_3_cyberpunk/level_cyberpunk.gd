extends Level

func _ready() -> void:
	Global.play_bgm(Global.BGM_CYBERPUNK)
	Global.player.set_collision_mask_value(8,true)

#func _on_teleportation_body_entered(body: Node2D) -> void:
	#play.show_curtain(Global.DIALOGUE_C_3_VECTORY_S)
	#play.clear_dialogue_connections()
	#play.dialogue.finished.connect(func():
		#play.switch_level(%Teleportation.target_level)
		#play.hide_curtain()
	#)
