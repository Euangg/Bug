extends Level


func _ready() -> void:
	Global.play_ambient(Global.AMBIENT_CAVE)
	Global.play_bgm(Global.BGM_CAVE)
