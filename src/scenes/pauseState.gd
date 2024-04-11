extends State

signal unpause

func _enter_state():
	get_tree().paused = true
	$"../../UI/PauseMenu".visible = true

func _exit_state():
	get_tree().paused = false
	$"../../UI/PauseMenu".visible = false

func _state_update(_delta: float):
	if Input.is_action_just_pressed("pause"):
		emit_signal("unpause")

func _state_physics_update(_delta: float):
	pass
