extends State
class_name hammerAttack

@export var orbAmount = 7


@onready var boss = $"../.."
@onready var player = $"../../../Player"
@onready var sm = $".."

var projectile_scene = preload("res://scripts/FireBoss/BossProjectile.tscn")

var finished = false


func spawnOrb(direction):
	var projectile = projectile_scene.instantiate()
	$"../..".add_child(projectile)
	projectile.global_position = boss.global_position
	
	projectile.set_direction(direction)
	

func _enter_state():
	var deviation = 0
	var angle = PI/(orbAmount - 1) 
	
	for x in range(1):
		deviation = 0
		for y in range(orbAmount):
			var direction = Vector2(cos(y * angle - deviation), sin(y * angle - deviation))
			spawnOrb(direction)
		await get_tree().create_timer(0.5).timeout
	finished = true
	
	
func _exit_state():
	sm.varience += 1
	finished = false


func _state_update(delta : float):
	print("P1orb")
	if sm.health < sm.health * 0.7 and finished:
		sm._change_state($"../Phase2")
	elif finished:
		sm._change_state($"../Phase1")
	
func _state_physics_update(delta : float):
	pass
