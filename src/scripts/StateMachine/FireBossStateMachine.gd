extends FiniteStateMachine


@export var health = 300
var max_health = health
var varience = 0
var phase3 = false

var melee_range = 30

func take_damage(dmg):
	health -= dmg
	print(health)

func _ready():
	get_node("Phase3")._initialize_state(self, root)
	super()
	

func _change_state(new_state: State):
	super(new_state)

func _process(delta):
	super(delta)
