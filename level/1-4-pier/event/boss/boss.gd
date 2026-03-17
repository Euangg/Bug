extends Node2D
const ENEMY_JUMPER = preload("uid://dhgk10ijnkpm1")

signal finish

var spawned=false
func _ready() -> void:
	%Label.visible=false
	process_mode=Node.PROCESS_MODE_DISABLED

func _on_finish() -> void:queue_free()

func wake():
	Global.fmod_play_bgm("event:/BGM/BGM_1_boss")
	process_mode=Node.PROCESS_MODE_INHERIT
	%Label.visible=true

func spawn_enemy():
	var points=%SpawnPoint.get_children()
	for p:Node2D in points:
		var e:EnemySpider=ENEMY_JUMPER.instantiate()
		e.direction=Enemy.Direction.LEFT
		e.position=p.position
		e.target=Global.player
		e.has_spawn_dust=true
		e.dead.connect(boss_killed)
		add_sibling(e)
	spawned=true

func boss_killed():%TimerEnd.start()

func _on_timer_end_timeout() -> void:
	finish.emit()
