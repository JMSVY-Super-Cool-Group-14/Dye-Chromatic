extends State
class_name enemyIdle

@export var move_speed := 10.0


@onready var enemy = $"../.."
@onready var player = $"../../../../../Player"
@onready var sm = $".."

var move_dir : Vector2
var wander_time : float




func random_wander():
	move_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)
	
func _enter_state():
	random_wander()
	
func _state_update(delta : float):
	if wander_time > 0:
		wander_time -= delta
	
	else:
		random_wander()
		
func _state_physics_update(delta : float):
	if enemy:
		enemy.velocity = move_dir * move_speed
	
	if player != null:
		var direction = player.global_position - enemy.global_position
		
		if sm.health <= 0:
			sm._change_state($"../Death")
	
		if direction.length() < sm.detection_range:
			sm._change_state($"../Chase")
		
		if direction.length() <= sm.attack_range:
			if sm.melee:
				sm._change_state($"../Attack")
			else:
				sm._change_state($"../RangeAttack")
	

	

