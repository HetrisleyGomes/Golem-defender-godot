extends Node2D

@export var ritual_amount: int = 1

@onready var ritual_area: Area2D = $Ritual_area

func deal_damage() -> void:
	var bodies = ritual_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			enemy.damage(ritual_amount)
