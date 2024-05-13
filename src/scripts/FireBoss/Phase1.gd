extends State
class_name phase1

@onready var boss = $"../.."
@onready var player = $"../../../../Player"
@onready var sm = $".."

var attack1 = true
var switch_timer = 2

func _choose_attack():
	if player.global_position - boss.global_position < sm.melee_range:
		sm._change_state($"../P1Melee")
	if attack1:
		sm._change_state($"../P1orbAttack")
	else:
		sm._change_state($"../P1Attack2")
	

func _enter_state():
	await get_tree().create_timer(switch_timer).timeout
	_choose_attack()

func _state_update(delta : float):
	pass
	
func _state_physics_update(delta : float):
	pass
