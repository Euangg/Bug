extends Control

func _ready() -> void:
	Global.play_bgm(Global.BGM_THEME)

func _on_button_pressed() -> void:
	Global.switch_scene(Global.SCENE_PLAY)

func _on_button_2_pressed() -> void:
	get_tree().quit()
