extends State
class_name npcIdle

@export var walking_break := 3.0

@onready var npc = $"../.."
@onready var player = $"../../../../Player"
@onready var sm = $".."

var cooldown = false


func _enter_state():
	cooldown = false
	get_tree().create_timer(walking_break).timeout.connect(func(): cooldown = true)
	
func _state_update(delta : float):
	if cooldown:
		sm._change_state($"../Walking")
		
func _state_physics_update(delta : float):
	pass
	
