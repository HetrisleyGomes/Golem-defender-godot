extends Node

@export var mobspawner: MobSpawner
@export var spawn_rate_per_minutes: float = 30
@export var initial_spawn_rate: float = 30
@export var wave_duration: float = 20

@export var break_intencity: float = 0.5

var time: float = 0.0

func _process(delta):
	# Se game over, ignora o resto
	if GameMenager.is_game_over: return
	time += delta
	# Aumento de dificuladade linear
	var spawn_rate = initial_spawn_rate + spawn_rate_per_minutes * (time / 60.0)
	
	# sistema de ondas
	var sin_wave = sin((time * TAU)/wave_duration)
	var wave = remap(sin_wave, -1.0, 1.0, break_intencity, 1)
	spawn_rate *= wave
	
	# Dificuldade
	mobspawner.mobs_per_minute = spawn_rate
