extends Node2D


const PROJECTILE_1 = preload("uid://db2c1jf6vflq5")
const PROJECTILE_THROWER = preload("uid://cwysknnbfaugv")
const PROJECTILE_FLYER = preload("uid://2lfwbxys80s8")

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_left"):
		var p:Projectile=PROJECTILE_FLYER.instantiate()
		p.position=get_local_mouse_position()
		p.velocity=Vector2(0,600)
		add_child(p)
