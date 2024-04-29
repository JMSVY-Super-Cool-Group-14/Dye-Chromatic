extends State
class_name npcInteract

@onready var npc = $"../.."
@onready var dialogue_box = $"../../../../Player/PlayerCam/DialogueBox"

func _enter_state():
	npc.velocity = Vector2.ZERO
	dialogue_box.start()
	
func talking():
	pass

func shopping():
	pass
	
func _state_update(delta : float):
	pass
	
func _state_physics_update(delta : float):
	pass
