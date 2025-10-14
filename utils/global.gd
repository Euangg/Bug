extends Node

const BGM_DEMO = preload("uid://liinacjn8yqe")
func play_bgm(music:AudioStream):
	%Bgm.stream=music
	%Bgm.play()
func _on_bgm_finished() -> void:%Bgm.play()
