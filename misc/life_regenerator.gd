extends Node2D

@export var amount: int = 10;

func _ready():
	$Area2D.body_entered.connect(on_body_entered)
	

func on_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		var player: Player = body
		body.heal(amount)
		body.meat_collected.emit()
		queue_free()
