extends AnimatedSprite2D

@onready var player: Area2D = $"../"
var projectile_val = false
var melee_val = false

func _ready():
	animation_looped.connect(end_attack)
	set_process(true)

func _process(delta):
	if !projectile_val and !melee_val:
		walk_idle()

	if !player.isSprinting:
		# Animation check
		if Input.is_action_just_pressed("ranged_attack"):
			projectile_val = true
			proj()
		elif Input.is_action_just_pressed("melee_attack"):
			melee_val = true
			melee()
	# Only debug information should be here, movement is removed
	#print("Player Position: ", player.position)
	#print("Viewport Size: ", get_viewport().size)

func end_attack():
	projectile_val = false
	melee_val = false

func walk_idle():
	if player.velocity.length() <= 0:
		animation = "idle"
		return
	
	# Walking animation
	if player.velocity.x > 0.25 or player.velocity.x < -0.25:
		animation = "walk_right"
		flip_h = false
		if player.velocity.x < 0:
			flip_h = true
	elif player.velocity.y > 0:
		animation = "walk_down"
	elif player.velocity.y < 0:
		animation = "walk_up"

func melee():
	print("Melee animation")
	if player.velocity.x > 0.25 or player.velocity.x < -0.25:
		animation = "melee_right"
		flip_h = false
		if player.velocity.x < 0:
			flip_h = true
	elif player.velocity.y > 0:
		animation = "melee_down"
	elif player.velocity.y < 0:
		animation = "melee_up"

func proj():
	print("Projectile animation")
	if player.rangedTarget.x != 0:
		animation = "proj_right"
		flip_h = false
		if player.rangedTarget.x < 0:
			flip_h = true
	elif player.rangedTarget.y > 0:
		animation = "proj_down"
	elif player.rangedTarget.y < 0:
		animation = "proj_up"
