extends State
class_name enemyChase


@export var move_speed := 40.0


@onready var enemy = $"../.."
@onready var player = $"../../../../Player"
@onready var sm = $".."


func _enter_state():
	print("Chase")

func _exit_state():
	pass
	
func _state_physics_update(delta : float):
	if player != null:
		var direction = player.global_position - enemy.global_position

		enemy.velocity = direction.normalized() * move_speed
		
		
		if sm.health <= 0:
			sm._change_state($"../Death")
			
		if direction.length() > sm.chase_range:
			print("Out of range")
			sm._change_state($"../Idle")
		
		if direction.length() <= sm.attack_range:
			print("Attack range")
			sm._change_state($"../Attack")
		

