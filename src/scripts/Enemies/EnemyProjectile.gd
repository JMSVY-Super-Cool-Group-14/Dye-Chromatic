extends projectile

func _ready():
	super()
	
func _process(delta: float):
	super(delta)
		
func set_direction(direction: Vector2):
	super(direction)
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		print("player hit")
		body.take_fixed_damage(damage)
		queue_free()


