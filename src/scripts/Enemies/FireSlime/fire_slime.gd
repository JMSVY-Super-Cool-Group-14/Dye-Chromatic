extends enemy

func recieve_knockeback(source_pos: Vector2, dmg, attack_type):
	super(source_pos, dmg, attack_type)

func _physics_process(delta):
	super(delta)
	
func _on_state_machine_took_dmg():
	super()
