extends State
class_name SlimeChase

@export var Slime : CharacterBody2D
@export var move_speed := 40.0
@export var detect_range := 50.0

@onready var player =  get_node("../../../Player")


func _enter_state():
	print("Chase")

func _exit_state():
	pass
	
func _state_physics_update(delta : float):
	if player != null:
		var direction = player.global_position - Slime.global_position
	
		if direction.length() < detect_range:
			Slime.velocity = direction.normalized() * move_speed
		
		else:
			Slime.velocity = Vector2.ZERO
			
		if direction.length() > 100:
			print("Out of range")
			get_node("..")._change_state($"../Idle")
		
		if direction.length() <= 10:
			print("Attack range")
			get_node("..")._change_state($"../Attack")
		

