extends FiniteStateMachine
class_name enemyStateMachine

@onready var hpbar = $"../HPbar"

@export var health = 100
@export var attack_range := 10.0
@export var detection_range := 50.0
@export var chase_range := 60.0
@export var melee = true


signal took_dmg

func take_damage(dmg):
	health -= dmg
	if health < 100:
		hpbar.visible = true
	elif health == 0:
		hpbar.visible = false
	hpbar.value = health
	took_dmg.emit()
	
func take_DOT_damage(dmg, duration):
	var tick = dmg / duration
	for n in range(0, dmg, tick):
		health -= tick
		took_dmg.emit()	
		await get_tree().create_timer(1).timeout
	

func _ready():
	super()
	get_node("Idle")._initialize_state(self, root)
	
	hpbar.max_value = 100
	hpbar.value = health
	hpbar.visible = false

func _change_state(new_state: State):
	super(new_state)

func _process(delta):
	super(delta)
	
	
	
	
