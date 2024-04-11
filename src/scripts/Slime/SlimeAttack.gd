extends State
class_name SlimeAttack

@export var Slime : CharacterBody2D
@export var attack_speed := 3.0
@export var attack_dmg := 1.0


@onready var player = get_node("../../../Player")
var cooldown = false
var timer = null


func attack():
	if !cooldown:
		print("attack")
		cooldown = true
		get_tree().create_timer(attack_speed).timeout.connect(func(): cooldown = false)
		
func _enter_state():
	attack()
	
func _state_update(delta : float):
	attack()
		
func _state_physics_update(delta : float):
	if player != null:
		var direction = player.global_position - Slime.global_position
		
		if direction.length() > 10:
			get_node("..")._change_state($"../Chase")

			
	

