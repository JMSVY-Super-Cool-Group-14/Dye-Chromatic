extends State
class_name phase1

@onready var boss = $"../.."
@onready var player = $"/root/Game/Player"
@onready var sm = $".."


var attack1 = true
var switch_timer = 4
var new_phase = false


func _choose_attack():
	if (player.global_position - boss.global_position).length() < sm.melee_range:
		sm._change_state($"../Melee")
	elif attack1:
		attack1 = false
		sm._change_state($"../P1orbAttack")
	else:
		attack1 = true
		sm._change_state($"../P1lineAttack")
	

func _enter_state():
	print("P1")
	await get_tree().create_timer(switch_timer).timeout
	if !new_phase:
		_choose_attack()

func _state_update(delta : float):
	if sm.health <= sm.max_health * 0.7:
		new_phase = true
		sm._change_state($"../Phase2")
	
func _state_physics_update(delta : float):
	pass
