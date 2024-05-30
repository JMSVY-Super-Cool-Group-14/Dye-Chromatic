extends State

signal pause

func _enter_state():
	# Check if the signal is already connected using Callable
	var callable = Callable(self, "show_mouse")
	if not Input.is_connected("joy_connection_changed", callable):
		Input.connect("joy_connection_changed", callable)
	
	if state_machine.get_controller():
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _exit_state():
	# Disconnect the signal when exiting the state to clean up
	var callable = Callable(self, "show_mouse")
	if Input.is_connected("joy_connection_changed", callable):
		Input.disconnect("joy_connection_changed", callable)

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _state_update(delta: float):
	if Input.is_action_just_pressed("pause"):
		emit_signal("pause")

func _state_physics_update(delta: float):
	pass

func show_mouse():
	# Toggle mouse mode visibility
	if Input.mouse_mode == Input.MOUSE_MODE_HIDDEN:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
