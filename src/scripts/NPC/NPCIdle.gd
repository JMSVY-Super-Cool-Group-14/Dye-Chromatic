extends State
class_name npcIdle

@export var walking_break := 3.0

@onready var npc = $"../.."
@onready var player = $"../../../../../../Player"
@onready var sm = $".."

func _enter_state():
	await get_tree().create_timer(walking_break).timeout
	sm._change_state($"../Walking")
	
func _state_update(delta : float):
	pass
		
func _state_physics_update(delta : float):
	pass
	
