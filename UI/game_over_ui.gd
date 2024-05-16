class_name GameOverUi
extends CanvasLayer

@onready var timeLabel: Label = %TimeLabel
@onready var monsterLabel: Label = %MonsterLabel
@onready var goldLabel: Label = %GoldLabel

@export var restart_deley: float = 5
var restart_cooldown: float
var gold_obteined: int

func _ready():
	timeLabel.text = GameMenager.time_elapsed_sring
	monsterLabel.text = str(GameMenager.meat_counter)
	goldLabel.text = str(GameMenager.money)
	restart_cooldown = restart_deley

func _process(delta):
	restart_cooldown -= delta
	if restart_cooldown <= 0:
		restart_game()

func restart_game():
	GameMenager.reset()
	get_tree().change_scene_to_file('res://menu.tscn')
