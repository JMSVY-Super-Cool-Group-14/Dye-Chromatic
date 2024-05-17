extends enemyChase

func _enter_state():
	super()
	
func _state_physics_update(delta : float):
	if player != null:
		var direction = player.global_position - enemy.global_position
		enemy.velocity = direction.normalized() * move_speed
		
		if sm.health <= 0:
			sm._change_state($"../Death")
			
		if direction.length() > 70:
			sm._change_state($"../Idle")
		
		if direction.length() <= 30:
			sm._change_state($"../RangeAttack")
		

