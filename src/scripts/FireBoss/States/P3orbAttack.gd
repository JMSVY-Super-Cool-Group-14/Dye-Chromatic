extends State

@export var orbAmount = 7
@export var orbLines = 6
@export var orbSpeed = 100
@export var orbDamage = 0

@onready var boss = $"../.."
@onready var player = $"../../../Areas/Global/Player"
@onready var sm = $".."

var projectile_scene = preload("res://scenes/Enemies/Fire Boss/Attacks/Waveprojectile.tscn")

var finished = false


func spawnOrb(direction):
	var projectile = projectile_scene.instantiate()
	boss.add_child(projectile)
	projectile.global_position = boss.global_position
	projectile.set_properties(orbSpeed, orbDamage, Vector2(1, 1))
	projectile.set_direction(direction)
	

func _enter_state():
	spawnOrb(player.global_position - boss.global_position)
	
	
func _exit_state():
	sm.varience += 1
	finished = false


func _state_update(delta : float):
	if finished:
		sm._change_state($"../Phase3")
	
func _state_physics_update(delta : float):
	pass
