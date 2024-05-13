class_name Player
extends CharacterBody2D

@export_category("Movement")
@export var speed: int = 3

@export_category("Sword")
@export var sword_damage: int = 2

@export_category("Ritual")
@export var ritual_damage: int = 1
@export var ritual_interval: float = 30.0
@export var ritual_scene: PackedScene

@export_category("Life")
@export var health: int = 100
@export var max_health: int = 100

@export_category("Death")
@export var death_prefab: PackedScene

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitboxArea
@onready var life_progress_bar: ProgressBar = $Life_progressbar

var input_vector: Vector2 = Vector2(0,0);
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var ritual_cooldown: float = 0.0

signal meat_collected(value:int)
signal money_collected(value:int)

func _ready():
	GameMenager.player = self
	meat_collected.connect(func(): GameMenager.meat_counter+=1)
	meat_collected.connect(func(value:int): GameMenager.meat_counter+=value)
	pass

func _process(delta):
	GameMenager.player_position = position
	# ler inputs
	read_input()
	
	# atacar
	update_attack_cooldown(delta)
	if Input.is_action_just_pressed("attack"):
		attack()
	
	# animação
	play_run_idle_animation()
	if not is_attacking:
		rotate_sprite()
	
	update_hitbox_detection(delta)
	
	# Ritual
	update_ritual(delta)
	
	# atualizar life bar
	life_progress_bar.max_value = max_health
	life_progress_bar. value = health

func _physics_process(delta) -> void:
	# Modificar a velocidade
	var target_valocity = input_vector * speed * 100
	if is_attacking:
		target_valocity *= 0.1
	velocity = lerp(velocity, target_valocity, 0.5)
	move_and_slide()

func update_attack_cooldown(delta: float) -> void:
	# atualizar cooldown
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			is_attacking = false
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")

func read_input() -> void:
	# Obter input vector
	input_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down", 0.15)
	
	# Atualizar is running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func play_run_idle_animation() -> void:
	# tocar animação
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")

func rotate_sprite() -> void:
	# girar sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true

func attack() -> void:
	if is_attacking:
		return
	# toca animação:
	animation_player.play("attack_side_1")
	# marcar ataque
	is_attacking = true;
	# configurar temporizador
	attack_cooldown = 0.6;

func update_ritual(delta) -> void:
	ritual_cooldown -= delta
	if ritual_cooldown > 0: return
	ritual_cooldown = ritual_interval
	# Criar o ritual
	var ritual = ritual_scene.instantiate()
	ritual.ritual_amount = ritual_damage
	add_child(ritual)

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

func update_hitbox_detection(delta:float) -> void:
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	
	hitbox_cooldown = 0.5
	
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var dano = enemy.dano
			damage(dano)

func damage(amount: int):
	if health <= 0: return
	health -= amount
	# piscar cor
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	# processar morte
	if health <= 0:
		die()

func die():
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		GameMenager.end_game()
		get_parent().add_child(death_object)
		queue_free()

func heal(amount: int) -> void:
	health += amount
	if health >= max_health:
		health = max_health
	# piscar cor
	modulate = Color.TURQUOISE
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
