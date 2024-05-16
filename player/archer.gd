extends Player

@export_category("Arrow")
@export var ArrowDamage: int = 2
@export var arrow_prefab: PackedScene

@onready var arrow_marker: Marker2D = %Arrow_Marker


func deal_damage() -> void:
	var arrow_scene = arrow_prefab.instantiate()
	
	if arrow_marker:
		arrow_scene.global_position = arrow_marker.global_position
	else:
		arrow_scene.global_position = global_position
	arrow_scene.damage = ArrowDamage
	if sprite.flip_h:
		arrow_scene.Arrow_direction = Vector2(-1,0)
		arrow_scene.flip()
	get_parent().add_child(arrow_scene)

func update():
	if GameMenager.meat_counter > 100 and ArrowDamage < 6:
		ArrowDamage = 6
	elif GameMenager.meat_counter > 60 and max_health < 150:
		max_health = 150
	elif GameMenager.meat_counter > 80 and attack_interval > 0.45:
		attack_interval = 0.45
		$AnimationPlayer.speed_scale = 3
	elif GameMenager.meat_counter > 70 and ritual_interval > 16:
		ritual_interval = 16
	elif GameMenager.meat_counter > 60 and speed < 4:
		speed = 4
	elif GameMenager.meat_counter > 50 and ArrowDamage < 4:
		ArrowDamage = 4
	elif GameMenager.meat_counter > 60 and ritual_damage < 4:
		ritual_damage = 4
	elif GameMenager.meat_counter > 30 and max_health < 125:
		max_health = 125
	elif GameMenager.meat_counter > 20 and speed < 3.5:
		speed = 3.5
	elif GameMenager.meat_counter > 10 and attack_interval > 0.55:
		attack_interval = 0.55
		$AnimationPlayer.speed_scale = 2
