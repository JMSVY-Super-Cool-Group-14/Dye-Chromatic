extends FiniteStateMachine

signal phase3_start

@export var move_speed = 40.0
@export var health = 1500
var max_health = health
var varience = 0
var phase3 = false
var hammer_location
var hammer_picked_up = true

var melee_range = 100

func take_damage(dmg, atk_type):
	if phase3 and atk_type == "range":
		health -= 1
	else:
		health -=dmg
	print(health)

func _ready():
	get_node("Phase3")._initialize_state(self, root)
	super()
	

func _change_state(new_state: State):
	print(current_state)
	super(new_state)
	print(current_state)
	
	if current_state.name == "Phase3":
		phase3_start.emit()

func _process(delta):
	super(delta)
	
