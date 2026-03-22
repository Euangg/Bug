extends Node2D

func _ready() -> void:
	%Label.visible=false

func wake():
	%Label.visible=true
	%AnimationPlayer.play("show")

func end():queue_free()

func _on_single_wake_trigger() -> void:wake()
