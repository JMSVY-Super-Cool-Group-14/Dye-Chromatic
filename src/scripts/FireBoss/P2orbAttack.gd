extends orbAttack

func _enter_state():
	orbSpeed = 100
	orbDamage = 0
	super()
	
	
func _exit_state():
	sm.varience += 1


func _state_update(delta : float):
	if sm.health < sm.health * 0.7 and finished:
		sm._change_state($"../Phase2")
	elif finished:
		sm._change_state($"../Phase1")
	
func _state_physics_update(delta : float):
	pass
