extends Node2D

var text:String

@onready var label: Label = $Label
func _ready() -> void:
	label.text=text
