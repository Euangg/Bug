extends Node2D

enum State{
	NULL,START,LOOP,END
}
var current_state:State=State.NULL
func _ready() -> void:pass

func _physics_process(delta: float) -> void:
	var next_state=current_state
	match current_state:
		State.NULL:next_state=State.START
		State.START:
			if %AnimationPlayer.is_playing():pass
			else:next_state=State.LOOP
		State.LOOP:
			if %Timer.is_stopped():next_state=State.END
		State.END:
			if %AnimationPlayer.is_playing():pass
			else:next_state=State.START
	
	if next_state==current_state:pass
	else:
		match next_state:
			State.START:%AnimationPlayer.play("start")
			State.LOOP:
				%Timer.start()
				%AnimationPlayer.play("loop")
			State.END:%AnimationPlayer.play("end")
		current_state=next_state
	#3/3.状态运行
	match current_state:
		State.START:pass
