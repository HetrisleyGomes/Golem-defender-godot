extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var moedas_label: Label = %MoedasLabel
@onready var meat_label: Label = %MeatLabel

func _ready():
	meat_label.text = str(GameMenager.meat_counter)
	moedas_label.text = str(GameMenager.money)

func _process(delta):
	timer_label.text = GameMenager.time_elapsed_sring
	meat_label.text = str(GameMenager.meat_counter)
	moedas_label.text = str(GameMenager.money)
