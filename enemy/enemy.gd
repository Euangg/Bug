class_name Enemy
extends Entity
const BOOM = preload("uid://ckl3f6gmbo15j")

signal dead
@export var hp:int=1
@onready var marker_boom: Marker2D = $Graphic/MarkerBoom
func die_leave_boom():
	var effect:Node2D=BOOM.instantiate()
	effect.position=marker_boom.global_position
	add_sibling(effect)
	dead.emit()
	queue_free()

func player_body_hit(body: Node2D) -> void:
	if hp>0:
		var player:Player=body
		player.is_hurted=true
		player.direction_hurt=direction
