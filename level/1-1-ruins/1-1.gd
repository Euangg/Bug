extends Level

func _ready() -> void:
	Global.play_ambient(Global.AMBIENT_1)
	Global.fmod_play_bgm("event:/BGM/BGM_1")
