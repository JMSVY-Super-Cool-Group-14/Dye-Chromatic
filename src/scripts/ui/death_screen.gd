extends CanvasLayer

@onready var restart_button = $"PanelContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Restart"
func _ready():
	restart_button.grab_focus()

func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")

func _on_restart_pressed():
	# TODO: Checkpoint logic
	get_tree().change_scene_to_file("res://scenes/game.tscn")
