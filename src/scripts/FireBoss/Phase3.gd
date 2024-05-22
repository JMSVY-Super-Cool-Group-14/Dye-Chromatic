extends State
class_name phase3

@onready var boss = $"../.."
@onready var player = $"../../../Player"
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
	await get_tree().create_timer(switch_timer).timeout
	if !new_phase:
		_choose_attack()

func _state_update(delta : float):
	pass
	
func _state_physics_update(delta : float):
	if sm.health <= 0:
		$"AnimatedSprite2D".play("Death")
