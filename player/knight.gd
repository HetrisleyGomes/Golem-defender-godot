extends Player

@export_category("Sword")
@export var sword_damage: int = 2

@onready var sword_area: Area2D = $SwordArea

func deal_damage() -> void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >= 0.4:
				enemy.damage(sword_damage)


func update():
	if GameMenager.meat_counter > 100 and sword_damage < 6:
		sword_damage = 6
	elif GameMenager.meat_counter > 60 and max_health < 150:
		max_health = 150
	elif GameMenager.meat_counter > 80 and attack_interval > 0.4:
		attack_interval = 0.45
		$AnimationPlayer.speed_scale = 3
	elif GameMenager.meat_counter > 70 and ritual_damage < 2:
		ritual_damage = 2
	elif GameMenager.meat_counter > 60 and speed < 5:
		speed = 5
	elif GameMenager.meat_counter > 50 and sword_damage < 4:
		sword_damage = 4
	elif GameMenager.meat_counter > 60 and ritual_interval > 8:
		ritual_interval = 8
	elif GameMenager.meat_counter > 30 and max_health < 125:
		max_health = 125
	elif GameMenager.meat_counter > 20 and speed < 4:
		speed = 4
	elif GameMenager.meat_counter > 10 and attack_interval > 0.5:
		attack_interval = 0.55
		$AnimationPlayer.speed_scale = 2
