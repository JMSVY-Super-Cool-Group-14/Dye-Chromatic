extends FiniteStateMachine
var control_avail:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	control_avail = Input.get_connected_joypads().size() > 0
	Input.joy_connection_changed.connect(connection_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_controller():
	return control_avail

func connection_changed(device, connected):
	control_avail = connected
	print(control_avail)
