class_name Enemy
extends Entity

@export var hp:int=1

@onready var marker_boom: Marker2D = $Graphic/MarkerBoom
func die_leave_boom():
	var effect:Node2D=Global.EFFECT_BOOM.instantiate()
	effect.global_position=marker_boom.global_position
	get_parent().add_child(effect)
	Global.play_sfx(Global.SFX_BOOM)
	queue_free()


func player_body_hit(body: Node2D) -> void:
	if hp>0:
		var player:Player=body
		player.is_hurted=true
		player.direction_hurt=direction
