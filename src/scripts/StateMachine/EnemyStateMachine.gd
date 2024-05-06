extends FiniteStateMachine
class_name enemyStateMachine


@export var health = 100
@export var attack_range := 10.0
@export var detection_range := 50.0
@export var chase_range := 60.0
@export var melee = true

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
	
	
	
	
