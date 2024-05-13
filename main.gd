extends Node

@export var Game_ui: CanvasLayer
@export var Game_over_ui: PackedScene

func _ready():
	GameMenager.game_over.connect(trigger_game_over)

func trigger_game_over():
	if Game_ui:
		Game_ui.queue_free()
		Game_ui = null
	
	var gameover: GameOverUi = Game_over_ui.instantiate()
	add_child(gameover)
