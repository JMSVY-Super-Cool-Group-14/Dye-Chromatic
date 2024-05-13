extends State

const end_screen = preload("res://scenes/ui/death_screen.tscn")

func _enter_state():
	var game_over = end_screen.instantiate()
	add_child(game_over)
	get_tree().paused = true

func _exit_state():
	pass
	
func _state_update(_delta: float):
	pass
func _state_physics_update(_delta: float):
	pass
