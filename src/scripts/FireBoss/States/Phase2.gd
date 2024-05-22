extends State
class_name phase2

@onready var boss = $"../.."
@onready var player = $"../../../Player"
@onready var sm = $".."

var attack1 = true
var switch_timer = 4

func _choose_attack():
	if (player.global_position - boss.global_position).length() < sm.melee_range:
		sm._change_state($"../Melee")
	if attack1:
		attack1 = false
		sm._change_state($"../P2orbAttack")
	else:
		attack1 = true
		sm._change_state($"../P2lineAttack")
	

func _enter_state():
	print("enter p2")
	await get_tree().create_timer(switch_timer).timeout
	_choose_attack()

func _state_update(delta : float):
	if sm.health < sm.health * 0.35:
		sm._change_state($"../Phase3")
	
	
func _state_physics_update(delta : float):
	pass

