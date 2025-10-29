extends Control


func _ready() -> void:
	if OS.has_feature("mobile"):Global.switch_scene(Global.UI_POLICY)
	else:Global.switch_scene(Global.UI_THEME)
