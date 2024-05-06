extends FiniteStateMachine


@export var health = 100

signal took_dmg

func take_damage(dmg):
	health -= dmg
	took_dmg.emit()
	
func take_DOT_damage(dmg, duration):
	var tick = dmg / duration
	for n in range(0, dmg, tick):
		health -= tick
		took_dmg.emit()	
		await get_tree().create_timer(1).timeout
	

func _ready():
	get_node("Idle")._initialize_state(self, root)
	super()
	

func _change_state(new_state: State):
	super(new_state)

func _process(delta):
	super(delta)
	
	
	
	