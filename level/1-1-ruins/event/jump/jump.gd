extends Node2D

func _ready() -> void:
	%CanvasLayer.visible=false

func _on_single_wake_trigger() -> void:
	%CanvasLayer.visible=true
	%AnimationPlayer.play("idle")

func _on_single_finish_trigger() -> void:
	print("dsadasd")
	var tip=Global.EFFECT_TIP.instantiate()
	tip.text="做得好！"
	tip.position=Global.player.marker_tip.position
	Global.player.add_child(tip)
	queue_free()
