extends Node2D

@export var enemy:Enemy=null
func _ready() -> void:
	%CanvasLayer.visible=false
	if enemy:enemy.dead.connect(kill_finish)

func kill_finish() -> void:
	var tip=Global.EFFECT_TIP.instantiate()
	tip.text="做得好！"
	tip.position=Global.player.marker_tip.position
	Global.player.add_child(tip)
	queue_free()

func _on_single_wake_tree_exiting() -> void:
	%CanvasLayer.visible=true
	%AnimationPlayer.play("idle")

func _on_single_finish_tree_exiting() -> void:queue_free()
