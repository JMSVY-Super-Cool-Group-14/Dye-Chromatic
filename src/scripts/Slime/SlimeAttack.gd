extends State
class_name enemyAttack

@export var enemy : CharacterBody2D
@export var attack_speed := 3.0
@export var attack_dmg := 2.0


@onready var player = get_node("../../../Player")
var cooldown = false
var timer = null

signal attacking

func attack():
	if !cooldown:
		attacking.emit()
		print("attack")
		cooldown = true
		get_tree().create_timer(attack_speed).timeout.connect(func(): cooldown = false)
		player.take_fixed_damage(attack_dmg)
		
func _enter_state():
	enemy.velocity = Vector2.ZERO
	attack()
	
func _state_update(delta : float):
	attack()
		
func _state_physics_update(delta : float):
	if player != null:
		var direction = player.global_position - enemy.global_position
		if $"..".health <= 0:
			$".."._change_state($"../Death")
		
		if direction.length() > 10:
			$".."._change_state($"../Chase")

			
	

