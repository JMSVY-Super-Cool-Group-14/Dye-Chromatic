extends State
class_name npcInteract

@onready var npc = $"../.."
@onready var dialogue_box = $"../../DialogueBox"

func _enter_state():
	npc.velocity = Vector2.ZERO
	dialogue_box.visible = true
	
func talking():
	pass

func shopping():
	pass
	
func _state_update(delta : float):
	pass
	
func _state_physics_update(delta : float):
	pass
