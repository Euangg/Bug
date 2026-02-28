extends Node2D
const MAN = preload("uid://cxn3qox4lrsrl")

signal finish

var num_enemy=0
var spawned=false
func _ready() -> void:
	%Label.visible=false
	process_mode=Node.PROCESS_MODE_DISABLED
	print("ready")
	
func _physics_process(delta: float) -> void:
	if spawned:
		if num_enemy<=0:finish.emit()

func _on_finish() -> void:queue_free()

func wake():
	process_mode=Node.PROCESS_MODE_INHERIT
	%Label.visible=true

func spawn_enemy():
	var points=%SpawnPoint.get_children()
	for p:Node2D in points:
		var e:Enemy=MAN.instantiate()
		e.direction=Enemy.Direction.LEFT
		e.position=p.position
		e.dead.connect(func():
			print("dead")
			num_enemy-=1)
		add_sibling(e)
		num_enemy+=1
	spawned=true
