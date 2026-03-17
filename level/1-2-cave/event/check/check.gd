extends Node2D


signal finish

@export var node:Node=null

func _ready() -> void:
	%Label.visible=false

func wake():
	%Label.visible=true
	%AnimationPlayer.play("show")
	if node:
		if node.get_child_count():%Label.text="不要怕"

func end():
	finish.emit()
	queue_free()

func _on_single_wake_body_entered(body: Node2D) -> void:
	wake()
