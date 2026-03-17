extends Control


func _on_button_pressed() -> void:
	Global.switch_scene(Global.UI_THEME)


func _on_button_2_pressed() -> void:
	Global.str_enter_level=Global.str_current_level
	Global.switch_scene(Global.UI_PLAY)


func _on_control_mouse_entered() -> void:
	Global.play_sfx(Global.SFX_BUTTON_ON)
