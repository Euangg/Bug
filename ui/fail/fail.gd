extends Control


func _on_button_pressed() -> void:
	Global.switch_scene(Global.UI_THEME)


func _on_button_2_pressed() -> void:
	Global.is_restart=true
	Global.switch_scene(Global.UI_PLAY)
