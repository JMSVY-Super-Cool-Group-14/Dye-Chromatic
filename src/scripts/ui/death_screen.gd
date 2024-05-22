extends CanvasLayer

@onready var restart_button = $"PanelContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Restart"

signal restart
signal exit

func _ready():
	restart_button.grab_focus()

func _on_quit_pressed():
	get_tree().quit()
	exit.emit()

func _on_back_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")
	exit.emit()

func _on_restart_pressed():
	get_tree().paused = false
	restart.emit()
