extends State

func _enter_state():
	get_tree().change_scene_to_file("res://scenes/ui/main.tscn")
	
func _exit_state():
	pass
	
func _state_update(_delta: float):
	pass
func _state_physics_update(_delta: float):
	pass
