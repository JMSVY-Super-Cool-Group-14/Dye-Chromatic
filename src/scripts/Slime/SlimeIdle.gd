extends State

@export var Slime : CharacterBody2D
@export var move_speed := 10.0

var move_dir : Vector2
var wander_time : float



func random_wander():
	move_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)
	print("Wander")
	
func _ennter_state():
	random_wander()
	
func _state_update(delta : float):
	if wander_time > 0:
		wander_time -= delta
	
	else:
		random_wander()
		
func _state_physics_update(delta : float):
	if Slime:
		Slime.velocity = move_dir * move_speed
		
	

	

