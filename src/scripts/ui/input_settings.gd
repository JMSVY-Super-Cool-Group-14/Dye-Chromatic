extends VBoxContainer

# Credit to DashNothing
# https://www.youtube.com/watch?v=ZDPM45cHHlI

@onready var input_button = preload("res://scenes/ui/input_button.tscn")
@onready var actions = $"./ScrollContainer/Actions"

var remapping:bool = false
var action_to_remap = null
var remapping_button = null

var control_avail

# Called when the node enters the scene tree for the first time.
func _ready():
	# Check for controller
	control_avail = Input.get_connected_joypads().size() > 0
	Input.joy_connection_changed.connect(connection_changed)

func _create_actions():
	InputMap.load_from_project_settings()
	for item in actions.get_children():
		item.queue_free()
		
	for action in InputMap.get_actions():
		var button = input_button.instantiate()
		var action_label = button.find_child("Action")
		var input_label = button.find_child("Input")
		
		action_label.text = action
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
			
		actions.add_child(button)
		button.pressed.connect(_on_button_pressed.bind(button, action))

func _input(event):
	if remapping:
		pass

func _on_button_pressed(button, action):
	if !remapping:
		remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("Input").text = "Press key..."

func connection_changed(_device, connected):
	control_avail = connected
	print("Connection changed", control_avail)
