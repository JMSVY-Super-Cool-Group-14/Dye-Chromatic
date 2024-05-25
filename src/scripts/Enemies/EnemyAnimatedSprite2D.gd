extends AnimatedSprite2D

@onready var charger = $".."
var charging_val = false
var last_move = "down"


func _ready():
	animation_looped.connect(end_attack)
	set_process(true)

func _process(delta):
	if !charging_val:
		walk_idle()

	# Only debug information should be here, movement is removed
	#print("Player Position: ", player.position)
	#print("Viewport Size: ", get_viewport().size)

func end_attack():
	charging_val = false

func walk_idle():
	if charger.velocity.length() <= 0:
		if last_move == "down":
			animation = "Idle_Down"
		elif last_move == "up":
			animation = "Idle_Up"
		elif last_move == "right":
			animation == "Idle_side"
			flip_h == true
		elif last_move == "left":
			animation = "Idle_side"
			flip_h = false
		return
	
	# Walking animation
	if charger.velocity.x > 0.25 or charger.velocity.x < -0.25:
		animation = "Move_Side"
		flip_h = true
		last_move = "right"
		if charger.velocity.x < 0:
			flip_h = false
			last_move = "left"
	elif charger.velocity.y > 0:
		animation = "Move_Down"
		last_move = "down"
	elif charger.velocity.y < 0:
		animation = "Move_Up"
		last_move = "up"

	
