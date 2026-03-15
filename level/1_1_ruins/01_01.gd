extends Level

const bgm = ("uid://ni7qqlmyq6uh")

func _ready() -> void:
	Global.play_ambient(Global.AMBIENT_1)
	Global.play_bgm(bgm)
