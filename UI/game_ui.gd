extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var moedas_label: Label = %MoedasLabel
@onready var meat_label: Label = %MeatLabel

func _ready():
	GameMenager.player.money_collected.connect(on_money_collected)
	meat_label.text = str(GameMenager.meat_counter)

func _process(delta):
	timer_label.text = GameMenager.time_elapsed_sring
	meat_label.text = str(GameMenager.meat_counter)

func on_money_collected(amount):
	GameMenager.money += amount
	moedas_label.text = str(GameMenager.money)
