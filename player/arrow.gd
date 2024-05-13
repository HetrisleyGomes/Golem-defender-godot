extends Area2D

@export var speed: float = 5
@export var damage: int
@export var Arrow_direction: Vector2 = Vector2(1,0)

@onready var area: CollisionShape2D = $CollisionShape2D

var autodestruct: float = 0.0

func _ready():
	autodestruct = 2.0

func _process(delta):
	translate(Arrow_direction*speed*100*delta)
	autodestruct -= delta
	if autodestruct > 0: return
	queue_free()

func deal_damage():
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			enemy.damage(damage)
			queue_free()

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		var enemy: Enemy = body
		enemy.damage(damage)
		queue_free()

func flip():
	$Arrow.flip_h = true
