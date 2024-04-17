extends State
class_name enemyChase

@export var enemy : CharacterBody2D
@export var move_speed := 40.0
@export var detect_range := 50.0

@onready var player =  get_node("../../../Player")


func _enter_state():
	print("Chase")

func _exit_state():
	pass
	
func _state_physics_update(delta : float):
	if player != null:
		var direction = player.global_position - enemy.global_position

		enemy.velocity = direction.normalized() * move_speed
		
		
		if $"..".health <= 0:
			$".."._change_state($"../Death")
			
		if direction.length() > 70:
			print("Out of range")
			$".."._change_state($"../Idle")
		
		if direction.length() <= 10:
			print("Attack range")
			$".."._change_state($"../Attack")
		

