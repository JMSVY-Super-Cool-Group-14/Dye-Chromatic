extends State
class_name phase3

@onready var boss = $"../.."
@onready var player = $"../../../Player"
@onready var sm = $".."


var attack1 = true
var switch_timer = 2
var new_phase = false


func _choose_attack():
	if !attack1:
		sm._change_state($"../Hammer")
	else:
		sm._change_state($"../P3orbAttack")
	"""
	if (player.global_position - boss.global_position).length() < sm.melee_range:
		sm._change_state($"../Melee")
	elif attack1:
		attack1 = false
		sm._change_state($"../P1orbAttack")
		
	else:
		attack1 = true
		sm._change_state($"../P1lineAttack")
		"""
	

func _enter_state():
	print("P3")
	sm.phase3 = true
	await get_tree().create_timer(switch_timer).timeout
	_choose_attack()

func _state_update(delta : float):
	pass
	
func _state_physics_update(delta : float):
	if sm.health <= 0:
		$"AnimatedSprite2D".play("Death")
