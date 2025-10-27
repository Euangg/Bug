extends Level

@onready var enemy_plasma_cannon: CharacterBody2D = $Enemy/EnemyPlasmaCannon

func _ready() -> void:
	super._ready()
	Global.play_bgm(Global.BGM_CYBERPUNK)
	Global.play_dialogue(Global.DIALOGUE_C_3_ENTER)
	play.player.clear_dead_connections()
	play.player.dead.connect(func():play.show_curtain(Global.DIALOGUE_C_3_FAILURE_S))
	play.dialogue.finished.connect(func():Global.switch_scene(Global.UI_FAIL))
	play.player.set_collision_mask_value(8,true)

func _on_teleportation_body_entered(body: Node2D) -> void:
	play.show_curtain(Global.DIALOGUE_C_3_VECTORY_S)
	play.clear_dialogue_connections()
	play.dialogue.finished.connect(func():
		play.switch_level(%Teleportation.target_level)
		play.hide_curtain()
	)

func _on_enemy_plasma_cannon_dead() -> void:
	play.player.set_collision_mask_value(8,false)
