extends AnimatedSprite2D

@onready var player:Area2D = $"../"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Animation check
	if !player.isAttacking:
		if player.velocity.length() <= 0:
			animation = "idle"
		else:
			walk()
	else:
		attack()

func walk():
	# Walking animation
	if player.velocity.x > 0.25 || player.velocity.x < -0.25:
		animation = "walk_right"
		flip_h = false
		if player.velocity.x < 0:
			flip_h = true
	elif player.velocity.y > 0:
		animation = "walk_down"
	elif player.velocity.y < 0:
		animation = "walk_up"	
		
func attack():
	print("Melee animation")
	# Melee animation
	if player.velocity.x > 0.25 || player.velocity.x < -0.25:
		animation = "melee_right"
		flip_h = false
		if player.velocity.x < 0:
			flip_h = true
	elif player.velocity.y > 0:
		animation = "melee_down"
	elif player.velocity.y < 0:
		animation = "melee_up"	
