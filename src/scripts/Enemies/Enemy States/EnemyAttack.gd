extends State
class_name enemyAttack

@export var attack_speed := 3.0
@export var attack_dmg := 2.0

@onready var enemy = $"../.."
@onready var player = $"/root/Game/Player"
@onready var sm = $".."

var cooldown = false
var timer = null
var chargeing = false
var charge_speed = 100
var start_pos
var c_direction

signal attacking

func charge():
	print("cha func")
	enemy.velocity = Vector2.ZERO
	start_pos = enemy.global_position
	await get_tree().create_timer(1).timeout
	c_direction = player.global_position - enemy.global_position
	chargeing = true
	

func attack():
	if !cooldown:
		print("atk func")
		attacking.emit()
		cooldown = true
		get_tree().create_timer(attack_speed).timeout.connect(func(): cooldown = false)
		charge()
		player.take_fixed_damage(attack_dmg)
		
func _enter_state():
	attack()
	
func _state_update(delta : float):
	attack()
		
func _state_physics_update(delta : float):
	print(enemy.velocity)
	if player != null:
		var direction = player.global_position - enemy.global_position
		if sm.health <= 0:
			sm._change_state($"../Death")
		
		if chargeing:
			enemy.velocity = c_direction.normalized() * charge_speed
			print(enemy.velocity)
			if (start_pos - enemy.global_position).length() <= 0:
				print((start_pos - enemy.global_position).length())
				chargeing = false
			elif enemy.velocity.length() <= 0:
				chargeing = false
		if direction.length() > sm.attack_range + 40:
			sm._change_state($"../Chase")

			
	

