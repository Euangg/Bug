extends Node2D

signal finish
var is_a_pressed:bool=false
var is_d_pressed:bool=false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("a"):is_a_pressed=true
	if Input.is_action_just_pressed("d"):is_d_pressed=true
	
	if is_a_pressed and is_d_pressed:finish.emit()

func _on_single_body_entered(body: Node2D) -> void:finish.emit()


func _on_finish() -> void:queue_free()
