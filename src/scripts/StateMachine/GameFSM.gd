extends FiniteStateMachine

@onready var player = $"../Player"
@onready var hpbar = $"../UI/MarginContainer/HPbar"
@export var speed:int = 100
var control_avail:bool
var hp
var stam

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	control_avail = Input.get_connected_joypads().size() > 0
	hp = player.hp
	hpbar.max_value = player.maxHP
	hpbar.value = hp
	
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
	if hp <= 0:
		print("You Died!")
		_change_state($GameOver)

func stamina_changed(stamina: int):
	stam = stamina
	$"../UI/Stamina/StaminaLabel".text = str(stamina)
	
	
func colour_changed(left, right, current):
	var combined = $"../UI/ColourControl/CombinedColour"
	var leftColour = $"../UI/ColourControl/LeftColour"
	var rightColour = $"../UI/ColourControl/RightColour"
	combined.self_modulate = player.colourWheel[current]
	leftColour.self_modulate = player.colourWheel[left]
	rightColour.self_modulate = player.colourWheel[right]

