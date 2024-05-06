extends State

signal unpause

func _enter_state():
	get_tree().paused = true
	$"../../Pause".visible = true
	$"../../UI".visible = false

func _exit_state():
	get_tree().paused = false
	$"../../Pause".visible = false
	$"../../UI".visible = true

func _state_update(_delta: float):
	if Input.is_action_just_pressed("pause"):
		emit_signal("unpause")

func _state_physics_update(_delta: float):
	pass
