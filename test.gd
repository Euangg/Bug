extends Node2D

const TIP = preload("uid://dmb2x8b3j0kgm")

func _ready() -> void:
	%EnemyJumper.target=%Player
	%EnemyJumper.has_spawn_dust=true


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_left"):
		var t=TIP.instantiate()
		t.position=get_global_mouse_position()
		add_child(t)
