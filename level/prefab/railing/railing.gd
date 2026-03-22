extends Node2D


func _ready() -> void:
	var rt:RectangleShape2D=%CollisionShape2D.shape
	rt.size.x=%TextureRect.size.x
	%CollisionShape2D.position.x=rt.size.x/2
