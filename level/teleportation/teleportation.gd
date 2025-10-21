extends Area2D

@export var target_level:String
@export var level_enter_point_order:int

func _on_body_entered(body: Node2D) -> void:
	if target_level:
		if body is Player:
			var node_play=body.get_parent()
			if node_play:
				node_play.switch_level(target_level)
				Global.is_player_entered=true
				Global.enter_point_order=level_enter_point_order
