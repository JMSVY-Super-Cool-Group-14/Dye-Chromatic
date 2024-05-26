extends State




@onready var boss = $"../.."
@onready var sm = $".."


func _enter_state():
	
	pass

func _exit_state():
	pass
	
func _state_physics_update(delta : float):
	var direction = sm.hammer_location - boss.global_position
	boss.velocity = direction.normalized() * sm.move_speed
	
	if sm.health <= 0:
		sm._change_state($"../Death")
		
	if direction.length() <= 10:
		$"../../../".get_children()[-1].queue_free()
		sm.hammer_picked_up = true
		sm._change_state($"../Phase3")
		
		

