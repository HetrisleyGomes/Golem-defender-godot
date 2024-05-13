extends Node2D

var value: int = 0

func _ready():
	var label: Label = %Label
	label.text = str(value)
