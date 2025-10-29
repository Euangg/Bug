extends Control


func _on_check_box_pressed() -> void:
	if %CheckBox.button_pressed:%Button.disabled=false
	else:%Button.disabled=true


func _on_button_pressed() -> void:
	Global.switch_scene(Global.UI_THEME)

func _on_button_2_pressed() -> void:
	get_tree().quit()
