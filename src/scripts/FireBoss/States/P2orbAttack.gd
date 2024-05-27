extends orbAttack

func _enter_state():
	orbSpeed = 150
	orbDamage = 15
	orbAmount = 7
	orbLines = 5
	scale = Vector2(1,1)
	super()
	
	
func _exit_state():
	sm.varience += 1
	finished = false


func _state_update(delta : float):
	if sm.health < sm.health * 0.35 and finished:
		sm._change_state($"../Phase3")
	elif finished:
		sm._change_state($"../Phase2")
	
func _state_physics_update(delta : float):
	pass
