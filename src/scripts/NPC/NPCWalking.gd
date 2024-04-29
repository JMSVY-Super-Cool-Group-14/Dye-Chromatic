extends State
class_name npcWalking

@export var move_speed := 10.0

@onready var npc = $"../.."
@onready var player = $"../../../../Player"
@onready var sm = $".."

var move_dir : Vector2
var wander_time : float




func random_wander():
	move_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)
	
func _enter_state():
	random_wander()
	
func _state_update(delta : float):
	print(wander_time)
	if wander_time > 0:
		wander_time -= delta
	
	else:
		npc.velocity = Vector2.ZERO
		sm._change_state($"../Idle")
		
func _state_physics_update(delta : float):
	if npc:
		npc.velocity = move_dir * move_speed
		
