extends Control

func _ready() -> void:
	Global.stop_ambient()
	Global.fmod_play_bgm("event:/BGM/BGM_theme")

func _on_button_pressed() -> void:
	Global.str_enter_level="1-1"
	Global.play_sfx(Global.SFX_BUTTON_CLICK)
	Global.switch_scene(Global.UI_INTRO)
	

func _on_button_2_pressed() -> void:
	get_tree().quit()
	Global.play_sfx(Global.SFX_BUTTON_CLICK)

func _on_control_mouse_entered() -> void:
	Global.play_sfx(Global.SFX_BUTTON_ON)


func _on_button_3_pressed() -> void:
	Global.str_enter_level="2-1"
	Global.play_sfx(Global.SFX_BUTTON_CLICK)
	Global.switch_scene(Global.UI_PLAY)
	


func _on_button_4_pressed() -> void:
	Global.str_enter_level="3-1"
	Global.play_sfx(Global.SFX_BUTTON_CLICK)
	Global.switch_scene(Global.UI_PLAY)
	
