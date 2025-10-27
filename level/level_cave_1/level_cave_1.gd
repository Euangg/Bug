extends Level


func _ready() -> void:
	super._ready()
	Global.play_ambient(Global.AMBIENT_CAVE)
	Global.play_bgm(Global.BGM_CAVE)
