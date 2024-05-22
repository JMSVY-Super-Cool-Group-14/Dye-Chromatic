extends State
class_name lineAttack


@export var lineSpeed = 50
@export var lineDamage = 0
@export var lineAmount = 5

@onready var boss = $"../.."
@onready var player = $"../../../Player"
@onready var sm = $".."

var line1 = preload("res://scripts/FireBoss/line1.tscn")
var line2 = preload("res://scripts/FireBoss/line2.tscn")
var line3 = preload("res://scripts/FireBoss/line3.tscn")

var line
var finished = false


func spawnLine(nr):
	if nr == 1:
		line = line1.instantiate()
	elif nr == 2:
		line = line2.instantiate()
	elif nr == 3:
		line = line3.instantiate()
	else:
		line == line1.instantiate()
		
	$"../..".add_child(line)
	line.global_position = boss.global_position
	line.set_direction(Vector2(0, 1))
	

func _enter_state():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	
	for x in range(lineAmount):
		var num = rng.randi_range(1, 4)
		print(num)
		spawnLine(num)
		await get_tree().create_timer(2).timeout
	
	await get_tree().create_timer(1).timeout
	finished = true

func _exit_state():
	finished = false


func _state_update(delta : float):
	if sm.health < sm.health * 0.7 and finished:
		sm._change_state($"../Phase2")
	elif finished:
		sm._change_state($"../Phase1")
	
func _state_physics_update(delta : float):
	pass
