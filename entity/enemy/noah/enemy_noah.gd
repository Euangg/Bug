class_name Noah
extends Node2D

signal dead

var is_hurted:bool=false
var boom_marks_l:Array
var boom_marks_r:Array
var boom_marks_m:Array
func _ready() -> void:
	boom_marks_l=%BoomL.get_children()
	boom_marks_r=%BoomR.get_children()
	boom_marks_m=%BoomM.get_children()

var boom_order=0
func _on_timer_boom_1_timeout() -> void:
	var b_l:Node2D=Global.EFFECT_BOOM.instantiate()
	b_l.global_position=boom_marks_l[boom_order].global_position
	var sc=randf_range(1,2)
	b_l.scale=Vector2(sc,sc)
	add_sibling(b_l)
	
	var b_r:Node2D=Global.EFFECT_BOOM.instantiate()
	b_r.global_position=boom_marks_r[boom_order].global_position
	sc=randf_range(1,2)
	b_r.scale=Vector2(sc,sc)
	add_sibling(b_r)
	
	Global.play_sfx(Global.SFX_BOOM)
	
	boom_order+=1
	if boom_order>=32:%TimerBoom2.start()
	else:%TimerBoom1.start()

var boom_order_2=0
func _on_timer_boom_2_timeout() -> void:
	var b:Node2D=Global.EFFECT_BOOM.instantiate()
	b.global_position=boom_marks_m[boom_order_2].global_position
	var sc=randf_range(1.2,3)
	b.scale=Vector2(sc,sc)
	var c=Color(5*randf(),5*randf(),5*randf(),1)
	b.modulate=c
	b.modulate.h
	add_sibling(b)
	Global.play_sfx(Global.SFX_BOOM)
	
	boom_order_2+=1
	if boom_order_2>=boom_marks_m.size():dead.emit()
	else:%TimerBoom2.start()
	


func _on_hit_box_area_entered(area: Area2D) -> void:
	if is_hurted:pass
	else:
		is_hurted=true
		Global.stun(0.5)
		%AnimationPlayer.stop()
		%TimerBoom1.start()
		
