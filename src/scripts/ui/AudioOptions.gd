extends VBoxContainer

@onready var check:CheckBox = $CheckBox
@onready var screen_default = Vector2(1024,600)
@onready var screen_options:OptionButton = $OptionButton 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_check_box_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		screen_options.disabled = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		screen_options.disabled = false

func _on_option_button_item_selected(index):
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		return
	
	if index == 0:
		DisplayServer.window_set_size(Vector2(1024,600))
	elif index == 1:
		DisplayServer.window_set_size(Vector2(2048,1200))
