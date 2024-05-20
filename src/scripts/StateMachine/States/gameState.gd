extends State

signal pause

func _enter_state():
	Input.joy_connection_changed.connect(show_mouse)
	
	if state_machine.get_controller():
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _exit_state():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _state_update(_delta: float):
	if Input.is_action_just_pressed("pause"):
		emit_signal("pause")

func _state_physics_update(_delta: float):
	pass
	
func show_mouse():
	if Input.mouse_mode == Input.MOUSE_MODE_HIDDEN:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
