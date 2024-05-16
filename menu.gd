extends Control

func _on_button_knight_button_down():
	GameMenager.player_selected = "Knight"
	print("Cavaleiro")
	change_scene()


func _on_button_archer_button_down():
	GameMenager.player_selected = "Archer"
	print("Arqueiro")
	change_scene()

func change_scene() -> void:
	get_tree().change_scene_to_file('res://main.tscn')
