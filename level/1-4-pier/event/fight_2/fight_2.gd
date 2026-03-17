extends Node2D
const MAN = preload("uid://cxn3qox4lrsrl")

signal finish

var num_enemy=0
var num_left_spawn_round=3
func _ready() -> void:
	%Label.visible=false
	process_mode=Node.PROCESS_MODE_DISABLED
	
func _physics_process(delta: float) -> void:
	if num_left_spawn_round<=0:
		if num_enemy<=0:finish.emit()

func _on_finish() -> void:queue_free()

func wake():
	process_mode=Node.PROCESS_MODE_INHERIT
	%Label.visible=true

func spawn_enemy():
	var points=%SpawnPoint.get_children()
	for p:Node2D in points:
		var e:Enemy=MAN.instantiate()
		e.position=p.position
		if e.position.x<400:e.direction=Enemy.Direction.RIGHT
		else:e.direction=Enemy.Direction.LEFT
		e.dead.connect(func():
			print("dead")
			num_enemy-=1)
		add_sibling(e)
		num_enemy+=1
	num_left_spawn_round-=1
	if num_left_spawn_round>0:%TimerSpawnEnemy.start()

func _on_timer_spawn_enemy_timeout() -> void:spawn_enemy()
