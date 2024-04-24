extends State
class_name npcInteract

@onready var npc = $"../.."

func _enter_state():
	npc.velocity = Vector2.ZERO
	print("hello there")
	
func talking():
	pass

func shopping():
	pass
	
func _state_update(delta : float):
	pass
	
func _state_physics_update(delta : float):
	pass
