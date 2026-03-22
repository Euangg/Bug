extends Area2D

var parent:Node2D=null
var count:int=0
func _ready() -> void:
	parent=get_parent()


func _on_body_entered(body: Node2D) -> void:
	count+=1
	refresh_trans()
func _on_body_exited(body: Node2D) -> void:
	count-=1
	refresh_trans()

func refresh_trans():
	if count>0:parent.modulate.a=0.5
	else:parent.modulate.a=1
