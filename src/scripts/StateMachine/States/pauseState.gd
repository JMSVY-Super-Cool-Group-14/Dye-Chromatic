extends State

@onready var sfx = $PauseSound

signal unpause

func _enter_state():
	get_tree().paused = true
	$"../../Pause".visible = true
	$"../../UI".visible = false
	state_machine._save()
	sfx.play()

func _exit_state():
	get_tree().paused = false
	$"../../Pause".visible = false
	$"../../UI".visible = true

func _state_update(_delta: float):
	if Input.is_action_just_pressed("pause"):
		emit_signal("unpause")

func _state_physics_update(_delta: float):
	pass
