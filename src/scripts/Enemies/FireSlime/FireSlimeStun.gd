extends enemyStun

@onready var sfx = $"../../AudioStreamPlayer2D"
	
func _enter_state():
	super()
	sfx.play()
	
func _state_update(delta : float):
	super(delta)

