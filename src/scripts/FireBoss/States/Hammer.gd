extends State
class_name hammerAttack

@onready var boss = $"../.."
@onready var player = $"/root/Game/Areas/Global/Player"
@onready var sm = $".."

var hammerDamage = 50

var hammer_scene = preload("res://scenes/Enemies/Fire Boss/Attacks/BossHammer.tscn")

var finished = false


func _enter_state():
	var hammer = hammer_scene.instantiate()
	$"../..".add_child(hammer)
	hammer.global_position = player.global_position +Vector2(0,-70)
	hammer.set_properties(hammerDamage)
	finished = true
	
func _exit_state():
	sm.varience += 1
	finished = false
	
func _state_update(delta : float):
	print(finished)
	if sm.health <= 0:
		$"AnimatedSprite2D".play("Death")
	if finished:
		sm._change_state($"../Phase3")
	
func _state_physics_update(delta : float):
	pass
