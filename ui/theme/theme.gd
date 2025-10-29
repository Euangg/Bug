extends Control

func _ready() -> void:
	Global.stop_ambient()
	Global.play_bgm(Global.BGM_THEME)

func _on_button_pressed() -> void:
	Global.is_restart=false
	Global.name_current_level="level_ruins"
	Global.switch_scene(Global.UI_PLAY)
	Global.play_sfx(Global.SFX_BUTTON_CLICK)

func _on_button_2_pressed() -> void:
	get_tree().quit()
	Global.play_sfx(Global.SFX_BUTTON_CLICK)

func _exit_tree() -> void:
	Global.stop_bgm()
