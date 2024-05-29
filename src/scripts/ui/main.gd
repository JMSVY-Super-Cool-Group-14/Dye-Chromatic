extends CanvasLayer

@onready var buttons = $"Center/Buttons"
@onready var options = $"Center/Options"
@onready var credits = $"Center/Credits"
@onready var bop = $Bop

# Called when the node enters the scene tree for the first time.
func _ready():
	if not FileAccess.file_exists("user://savegame.save"):
		$"Center/Buttons/NewGame".grab_focus()
	else:
		$"Center/Buttons/Continue".disabled = false
		print("Continue available")
		$"Center/Buttons/Continue".grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mouse_entered():
	bop.play(0.0)

func _on_continue_pressed():
	start()
	
func _on_new_game_pressed():
	#Delete savefile
	if FileAccess.file_exists("user://savegame.save"):
		var dir = DirAccess.open("user://")
		dir.remove_absolute("user://savegame.save") 
	
	start()

func _on_exit_game_pressed():
	get_tree().quit()

func _close_screens():
	options.visible = false
	credits.visible = false
	buttons.visible = true
	$"Center/Buttons/NewGame".grab_focus()

func _on_credits_pressed():
	credits.visible = true
	buttons.visible = false
	$"Center/Credits/Close".grab_focus()

func _on_options_pressed():
	options.visible = true
	buttons.visible = false
	$"Center/Options/Close".grab_focus()

func start():
	Input.start_joy_vibration(0, 1, 1, 0.15)
	get_tree().change_scene_to_file("res://scenes/game.tscn")
