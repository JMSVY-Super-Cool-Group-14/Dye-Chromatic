extends FiniteStateMachine


@export var health = 100

signal took_dmg

func take_damage(dmg):
	health -= dmg
	took_dmg.emit()
	

func _ready():
	get_node("Idle")._initialize_state(self, root)
	super()
	

func _change_state(new_state: State):
	super(new_state)

func _process(delta):
	super(delta)
	
	
	
	
