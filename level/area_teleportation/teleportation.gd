extends Area2D

@export var target_level:String
@export var level_enter_point_order:int

func _on_body_entered(body: Node2D) -> void:
	if Global.is_teleportation:return
	if target_level:
		if body is Player:
			var node_play:Play=body.get_parent()
			if node_play:
				Global.is_teleportation=true
				var tween:Tween=create_tween()
				tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
				tween.tween_property(Global.color_rect,"color:a",1,0.5)
				await tween.finished
				
				node_play.switch_level(target_level)
				Global.enter_point_order=level_enter_point_order
