extends State
class_name orbAttack

@export var orbAmount = 5
@export var orbLines = 4
@export var orbSpeed = 50
@export var orbDamage = 0
@export var scale = Vector2(0.9, 0.9)

@onready var sm = $".."
@onready var boss = $"../.."

var projectile_scene = preload("res://scenes/Enemies/Fire Boss/Attacks/BossProjectile.tscn")

var finished = false


func spawnOrb(direction):
	var projectile = projectile_scene.instantiate()
	boss.add_child(projectile)
	projectile.global_position = boss.global_position
	projectile.set_properties(orbSpeed, orbDamage, scale)
	projectile.set_direction(direction)
	

func _enter_state():
	var deviation = 0
	var angle = PI/(orbAmount - 1) 
	
	for x in range(orbLines):
		deviation =  x * (PI/(orbAmount -1)/orbLines)
		for y in range(orbAmount):
			var direction = Vector2(cos(y * angle - deviation), sin(y * angle - deviation))
			spawnOrb(direction)
		await get_tree().create_timer(1).timeout
	await get_tree().create_timer(1).timeout
	finished = true
	
	
func _exit_state():
	sm.varience += 1
	finished = false


func _state_update(delta : float):
	if sm.health < sm.health * 0.7 and finished:
		sm._change_state($"../Phase2")
	elif finished:
		sm._change_state($"../Phase1")
	
func _state_physics_update(delta : float):
	pass
