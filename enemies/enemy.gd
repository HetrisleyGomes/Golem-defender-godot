class_name Enemy
extends Node2D

@export_category("Infos")
@export var dano: int = 1
@export var health: int = 10
@export var death_prefab: PackedScene

@export_category("Drops")
@export var money_getter: int = 2
@export var drop_Chance: float = 0.1
@export var drop_itens: Array[PackedScene]
@export var drop_chances: Array[float]

var damagedigitprefab: PackedScene
var markerposition: Marker2D

func _ready():
	damagedigitprefab = preload("res://misc/damage_digits.tscn")
	markerposition = $DamageDigitMarker

func damage(amount: int):
	health -= amount
	# piscar cor
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	# Criar o damage digit
	var damagedigit = damagedigitprefab.instantiate()
	damagedigit.value = amount
	if markerposition:
		damagedigit.global_position = markerposition.global_position
	else:
		damagedigit.global_position = global_position
	get_parent().add_child(damagedigit)
	# processar morte
	if health <= 0:
		die()

func die():
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
		# Drop
		var valor = randf()
		if drop_Chance <= valor:
			drop_item()
		# Delete Instancia
		queue_free()

func get_random_drop_item() -> PackedScene:
	if drop_itens.size() == 1:
		return drop_itens[0]
	
	var max_chances: float = 0.0
	for chances in drop_chances:
		max_chances += chances
	# Jogar dado:
	var random_value = randf() * max_chances
	
	# Girar roleta
	var needle: float = 0.0
	
	for i in drop_itens.size():
		var drop_item = drop_itens[i]
		var drop_chance = drop_chances[i] if i < drop_chances.size() else 1;
		if random_value <= drop_chance + needle:
			return drop_item
		needle += drop_chance
	
	return drop_itens[0]

func drop_item():
	var item = get_random_drop_item().instantiate()
	item.global_position = global_position
	get_parent().add_child(item)
	
