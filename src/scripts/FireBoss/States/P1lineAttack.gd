extends State
class_name lineAttack


@export var lineSpeed = 50
@export var lineDamage = 15
@export var lineAmount = 5
@export var spawnRate = 3

@onready var boss = $"../.."
@onready var player = $"/root/Game/Player"
@onready var sm = $".."

var line1 = preload("res://scenes/Enemies/Fire Boss/Attacks/line1.tscn")
var line2 = preload("res://scenes/Enemies/Fire Boss/Attacks/line2.tscn")

var line
var finished = false


func spawnLine(nr, deviation):
	if nr == 1:
		line = line1.instantiate()
		deviation *= 20
	elif nr == 2:
		line = line2.instantiate()
		deviation *= 10
	else:
		line == line1.instantiate()


	$"../..".add_child(line)
	line.global_position = boss.global_position + Vector2(deviation, 0)
	
	line.set_properties(lineSpeed, lineDamage)
	line.set_direction(Vector2(0, 1))
	

func _enter_state():
	var rng = RandomNumberGenerator.new()
	var randDev =  RandomNumberGenerator.new()
	rng.randomize()
	randDev.randomize()
	
	
	for x in range(lineAmount):
		var num = rng.randi_range(1, 4)
		var deviation = randDev.randi_range(-10,11)
		spawnLine(1, deviation)
		await get_tree().create_timer(spawnRate).timeout
	
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
