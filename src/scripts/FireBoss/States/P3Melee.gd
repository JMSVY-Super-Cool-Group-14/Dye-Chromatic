extends State

@onready var boss = $"../.."
@onready var player = $"../../../Player"
@onready var sm = $".."

@export var speed = 50
@export var damage = 30


var melee_scene = preload("res://scenes/Enemies/Fire Boss/Attacks/BossMelee.tscn")

var finished = false


func spawnHand():
	var hand = melee_scene.instantiate()
	$"../..".add_child(hand)
	hand.global_position = boss.global_position
	var direction = player.global_position-boss.global_position
	var orthogonal = Vector2(-direction.y, direction.x)
	hand.set_direction(orthogonal)
	

func _enter_state():
	spawnHand()
	await get_tree().create_timer(1).timeout
	finished = true
	
	
func _exit_state():
	finished = false


func _state_update(delta : float):
	if finished:
		sm._change_state($"../Phase3")
	if sm.health <= 0:
		sm._change_state($"../Death")
	

