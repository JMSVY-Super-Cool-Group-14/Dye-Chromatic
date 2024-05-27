extends State

@export var orbAmount = 7
@export var orbLines = 6
@export var orbSpeed = 100
@export var orbDamage = 30

@onready var boss = $"../.."
@onready var player = $"../../../Areas/Global/Player"
@onready var sm = $".."

var projectile_scene = preload("res://scenes/Enemies/Fire Boss/Attacks/Waveprojectile.tscn")

var finished = false
var move = false


func spawnOrb(direction):
	var projectile = projectile_scene.instantiate()
	boss.add_child(projectile)
	projectile.global_position = boss.global_position
	projectile.set_properties(orbSpeed, orbDamage, Vector2(1.5,1.5))
	projectile.set_direction(direction)
	

func _enter_state():
	print("p3orb")
	spawnOrb(player.global_position - boss.global_position)
	move = true
	await get_tree().create_timer(5).timeout
	finished = true
	
	
func _exit_state():
	sm.varience += 1
	finished = false


func _state_update(delta : float):
	if finished:
		sm._change_state($"../Phase3")
	if sm.health <= 0:
		sm._change_state($"../Death")
	
func _state_physics_update(delta : float):
	if move:
		var direction = player.global_position - boss.global_position
		boss.velocity = direction.normalized() * sm.move_speed
