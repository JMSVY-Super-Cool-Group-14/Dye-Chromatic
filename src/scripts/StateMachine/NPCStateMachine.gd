extends FiniteStateMachine
class_name npcStateMachine

func interact():
	pass

func _ready():
	get_node("Idle")._initialize_state(self, root)
	super()
	
	
func _change_state(new_state: State):
	super(new_state)

func _process(delta):
	super(delta)

