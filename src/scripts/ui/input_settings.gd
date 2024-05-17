extends VBoxContainer

# Credit to DashNothing
# https://www.youtube.com/watch?v=ZDPM45cHHlI

@onready var input_button = preload("res://scenes/ui/input_button.tscn")
@onready var actions = $"./ScrollContainer/Actions"

var remapping:bool = false
var action_to_remap = null
var remapping_button = null

var regex = RegEx.new()
var control_avail
var input_actions = {
	"move_down": "Move Down",
	"move_up": "Move Up",
	"move_right": "Move Right",
	"move_left": "Move Left",
	"ranged_attack": "Projectile",
	"melee_attack": "Melee",
	"left_colour": "Toggle Colour Left",
	"right_colour": "Toggle Colour Right",
	"aim_down": "Aim Down",
	"aim_up": "Aim Up",
	"aim_left": "Aim Left",
	"aim_right": "Aim Right",
	"pause": "Pause",
	"special_attack": "Special",
	"interact": "Interact",
	"ultimate_attack": "Ultimate"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	# Check for controller
	control_avail = Input.get_connected_joypads().size() > 0
	Input.joy_connection_changed.connect(connection_changed)
	
	regex.compile("")
	_create_actions()

func _create_actions():
	InputMap.load_from_project_settings()
	for item in actions.get_children():
		item.queue_free()
		
	for action in input_actions:
		var button = input_button.instantiate()
		var action_label = button.find_child("Action")
		var input_label = button.find_child("InputKey")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
			
		actions.add_child(button)
		button.pressed.connect(_on_button_pressed.bind(button, action))

func _input(event):
	if remapping:
		if event is InputEventKey && event.pressed:
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()

func _update_action_list(button, event):
	button.find_child("InputKey").text = event.as_text().trim_suffix(" (Physical)")

func _on_button_pressed(button, action):
	if !remapping:
		remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("InputKey").text = "Press key..."

func connection_changed(_device, connected):
	control_avail = connected
	print("Connection changed", control_avail)
