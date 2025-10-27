extends Level

func _ready() -> void:
	super._ready()
	Global.play_ambient(Global.AMBIENT_1)

func _on_area_2d_body_entered(body: Node2D) -> void:
	Global.play_bgm(Global.BGM_RUINS)
	%AreaBgm.set_deferred("monitoring",false)
