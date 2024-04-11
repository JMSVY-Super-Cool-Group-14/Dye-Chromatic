extends Panel

signal unpause

@onready var buttons = $"Center/Buttons"
@onready var options = $"Center/Options"

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(func(): $"Center/Buttons/Resume".grab_focus())

func _on_exit_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")

func _on_exit_game_pressed():
	get_tree().quit()

func _close_option():
	options.visible = false
	buttons.visible = true
	$"Center/Buttons/Resume".grab_focus()

func _on_options_pressed():
	options.visible = true
	buttons.visible = false
	$"Center/Options/Close".grab_focus()

func _on_resume_pressed():
	emit_signal("unpause")
