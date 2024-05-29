extends FiniteStateMachine

# References to game objects
@onready var player = $"/root/Game/Areas/Global/Player"
@onready var hpbar = $"../UI/MarginContainer/VBoxContainer/HPbar"
@onready var staminabar = $"../UI/MarginContainer/VBoxContainer/Staminabar"
@onready var camera: Camera2D = get_node("/root/Game/Areas/Global/Player/PlayerCam")
@onready var player_boundaries: Node = get_node("/root/Game/Areas/Global/Player/PlayerBoundaries")
@onready var audio =  $"/root/Game/Music/AudioStreamPlayer2D"

@export var speed:int = 100
var control_avail:bool

# Saved variables
var check_point_pos:Vector2 = Vector2(231, 235)
var check_point:Area2D = null
var hp
var stam
var area:String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	control_avail = Input.get_connected_joypads().size() > 0
	
	staminabar.max_value = player.maxStamina
	load_game()
	
	# Connect signals
	Input.joy_connection_changed.connect(connection_changed)
	$Pause.unpause.connect(func(): _change_state($InGame))
	$"../Pause/PauseMenu".unpause.connect(func(): _change_state($InGame))
	$InGame.pause.connect(func(): _change_state($Pause))
	player.hp_change.connect(hp_changed)
	player.colour_change.connect(colour_changed)
	player.stamina_change.connect(stamina_changed)

func _change_state(new_state: State):
	super(new_state)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)

func _physics_process(delta):
	super(delta)

func get_controller():
	return control_avail

func get_speed():
	return speed

func connection_changed(_device, connected):
	control_avail = connected
	print("Connection changed", control_avail)

func hp_changed(health:int):
	hp = health
	hpbar.value = hp
	if hp <= 0 and current_state.name != "GameOver":
		print("You Died!")
		_change_state($GameOver)

func stamina_changed(stamina: int):
	stam = stamina
	staminabar.value = stam	
	
func colour_changed(left, right, current):
	var combined = $"../UI/ColourControl/CombinedColour"
	var leftColour = $"../UI/ColourControl/LeftColour"
	var rightColour = $"../UI/ColourControl/RightColour"
	combined.self_modulate = player.colourWheel[current]
	leftColour.self_modulate = player.colourWheel[left]
	rightColour.self_modulate = player.colourWheel[right]

func save_checkpoint(pos:Vector2, obj:Area2D):
	check_point_pos = pos
	check_point = obj

func load_game():
	if FileAccess.file_exists("user://savegame.save"):
		var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
		while save_game.get_position() < save_game.get_length():
			var json_string = save_game.get_line()

			# Creates the helper class to interact with JSON
			var json = JSON.new()

			# Check if there is any error while parsing the JSON string, skip in case of failure
			var parse_result = json.parse(json_string)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
				continue
				
			# Get the data from the JSON object
			var node_data = json.get_data()
			player.hp = node_data["hp"]
			
			if node_data["checkpoint"] != null:
				set_player(Rect2(Vector2(0, 800), Vector2(1817*0.5, 735)), Rect2(Vector2(10, 810*0.5), Vector2(1807*0.5, 810 + 300)), Vector2(node_data["checkpoint_x"], node_data["checkpoint_y"]))
			
			set_area(node_data["location"])

	hp = player.hp
	hpbar.max_value = player.maxHP
	hpbar.value = hp

func _save():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_dict = {
		"checkpoint_x": check_point_pos.x,
		"checkpoint_y": check_point_pos.y,
		"hp": player.hp,
		"checkpoint": check_point,
		"location": area
	}
	var json_string = JSON.stringify(save_dict)
	save_game.store_line(json_string)

func set_area(location):
	if location == "PositionBossArea" || "PositionBoss":
		audio.stream = load("res://assets/audio/Music/Mountain_V1.wav")
		audio.play()
	area = location

func set_player(camera_bounds:Rect2, player_bounds:Rect2, pos:Vector2) -> void:
	player.teleport(pos)
	camera.update_bounds(camera_bounds)
	player_boundaries.update_bounds(player_bounds)
