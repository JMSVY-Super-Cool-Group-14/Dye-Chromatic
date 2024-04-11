extends CanvasLayer

@onready var buttons = $"Center/Buttons"
@onready var options = $"Center/Options"
@onready var credits = $"Center/Credits"
@onready var bop = $Bop

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mouse_entered():
	bop.play(0.0)

func _on_new_game_pressed():
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_exit_game_pressed():
	get_tree().quit()

func _close_screens():
	options.visible = false
	credits.visible = false
	visible = true

func _on_credits_pressed():
	credits.visible = true
	visible = false

func _on_options_pressed():
	options.visible = true
	visible = false
