extends Level

func _ready() -> void:
	super._ready()
	Global.play_ambient(Global.AMBIENT_TUTORIAL)
	Global.play_bgm(Global.BGM_TUTORIAL_MIDDLE)
