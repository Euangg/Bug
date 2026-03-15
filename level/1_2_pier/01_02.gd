extends Level


func _ready() -> void:
	%Fight1.wake()

func _on_fight_1_finish() -> void:%Fight2.wake()
func _on_fight_2_finish() -> void:%Fight3.wake()
func _on_fight_3_finish() -> void:%Boss.wake()
