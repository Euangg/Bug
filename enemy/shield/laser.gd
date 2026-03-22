extends Projectile

func _physics_process(delta: float) -> void:
	var shape:RectangleShape2D=%CollisionShape2D.shape
	shape.size.x=%Laser1.size.x
	%CollisionShape2D.position.x=shape.size.x/2
	
	position+=velocity*delta

func shoot():
	velocity.x=650*scale.x
	%Timer.start()
	
func die() -> void:queue_free()
