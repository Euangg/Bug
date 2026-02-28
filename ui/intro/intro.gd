extends Control

var line_order:int=1
var played:bool=false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("j"):start_game()
	if Input.is_action_just_pressed("mouse_left"):
		match line_order:
			1:
				if %AnimationPlayer.is_playing():%AnimationPlayer.advance(99)
				else:
					if played:
						%AnimationPlayer.play("line_2")
						played=false
						line_order=2
					else:%AnimationPlayer.play("line_1")
			2:
				if %AnimationPlayer.is_playing():%AnimationPlayer.advance(99)
				else:
					if played:
						%AnimationPlayer2.play("event")
						played=false

func start_game():Global.switch_scene(Global.UI_PLAY)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	played=true
