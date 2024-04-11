extends FiniteStateMachine

@export var speed:int = 100
var control_avail:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	control_avail = Input.get_connected_joypads().size() > 0
	Input.joy_connection_changed.connect(connection_changed)
	$Pause.unpause.connect(func(): _change_state($InGame))
	$"../UI/PauseMenu".unpause.connect(func(): _change_state($InGame))
	$InGame.pause.connect(func(): _change_state($Pause))

func _change_state(new_state: State):
	super(new_state)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)

func _physics_process(delta):
	super(delta)

func get_hp():
	pass

func get_controller():
	return control_avail

func get_speed():
	return speed

func connection_changed(device, connected):
	control_avail = connected
	print(control_avail)
