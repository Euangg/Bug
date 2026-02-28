extends Node2D


@export var enemy:Enemy=null
signal finish

func _ready() -> void:
	%CanvasLayer.visible=false
	if enemy:enemy.dead.connect(kill_finish)

func kill_finish() -> void:
	var tip=Global.EFFECT_TIP.instantiate()
	tip.text="做得好！"
	tip.position=Global.player.marker_tip.position
	Global.player.add_child(tip)
	finish.emit()

func _on_single_wake_body_entered(body: Node2D) -> void:
	%CanvasLayer.visible=true
	%AnimationPlayer.play("idle")

func _on_single_finish_body_entered(body: Node2D) -> void:
	finish.emit()

func _on_finish() -> void:queue_free()
