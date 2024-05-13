extends Node

@export var speed: float = 1.0
var enemy: Enemy
var sprite: AnimatedSprite2D

func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")

func _physics_process(delta)-> void:
	# Se game over, ignora o resto
	if GameMenager.is_game_over: return
	
	var player_position = GameMenager.player_position
	var diference = player_position - enemy.position
	var input_vector = diference.normalized()
	# mover o personagem
	enemy.velocity = input_vector * speed * 100
	enemy.move_and_slide()
	# girar sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
