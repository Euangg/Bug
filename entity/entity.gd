class_name Entity
extends CharacterBody2D
enum Direction{LEFT=-1,RIGHT=1}
@export var direction:Direction=Direction.RIGHT:
	set(v):
		direction=v
		if not is_node_ready():await ready
		%Direction.scale.x=direction

const gravity=4800

@export var hp:int
var is_hurted:bool=false
var direction_hurt:Direction
