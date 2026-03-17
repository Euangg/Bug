extends Node2D

signal finish
func _ready() -> void:
	%Label.visible=false

func wake():
	%Label.visible=true
	%AnimationPlayer.play("show")

func end():
	finish.emit()
	queue_free()

func _on_single_wake_body_entered(body: Node2D) -> void:
	wake()
