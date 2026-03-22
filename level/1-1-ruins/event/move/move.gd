extends Node2D

var is_a_pressed:bool=false
var is_d_pressed:bool=false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("a"):
		is_a_pressed=true
		check()
	if Input.is_action_just_pressed("d"):
		is_d_pressed=true
		check()

func check():
	if is_a_pressed and is_d_pressed:
		var tip=Global.EFFECT_TIP.instantiate()
		tip.text="做得好！"
		tip.position=Global.player.marker_tip.position
		Global.player.add_child(tip)
		queue_free()

func _on_single_trigger() -> void:queue_free()
