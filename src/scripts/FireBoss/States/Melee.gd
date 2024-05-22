extends State
class_name bossMelee

@onready var boss = $"../.."
@onready var player = $"../../../Player"
@onready var sm = $".."


@export var orbAmount = 7
@export var orbLines = 6
@export var orbSpeed = 50
@export var orbDamage = 0


var melee_scene = preload("res://scripts/FireBoss/BossMelee.tscn")

var finished = false


func spawnHand():
	var hand = melee_scene.instantiate()
	$"../..".add_child(hand)
	hand.global_position = boss.global_position
	hand.set_direction(Vector2(-1,0))
	

func _enter_state():
	spawnHand()
	await get_tree().create_timer(1).timeout
	finished = true
	
	
func _exit_state():
	finished = false


func _state_update(delta : float):
	print("P1orb")
	if sm.health < sm.health * 0.7 and finished:
		sm._change_state($"../Phase2")
	elif finished:
		sm._change_state($"../Phase1")
	
func _state_physics_update(delta : float):
	pass

