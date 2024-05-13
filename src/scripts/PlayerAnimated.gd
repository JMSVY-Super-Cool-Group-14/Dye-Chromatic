extends AnimatedSprite2D

@onready var player:Area2D = $"../"
var projectile_val = false
var melee_val = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_looped.connect(end_attack)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if !projectile_val && !melee_val:
		walk_idle()
	
	if player.isSprinting == false:
		# Animation check
		if Input.is_action_just_pressed("ranged_attack"):
			projectile_val = true
			proj()
		elif Input.is_action_just_pressed("melee_attack"):
			melee_val = true
			melee()
	

func end_attack():
	projectile_val = false
	melee_val = false

func walk_idle():	
	if player.velocity.length() <= 0:
		animation = "idle"
		return
	
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
		
func melee():
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

func proj():
	print("Projectile animation")
	#Projectile animation
	if player.rangedTarget.x != 0:
		animation = "proj_right"
		flip_h = false
		if player.rangedTarget.x < 0:
			flip_h = true
	elif player.rangedTarget.y > 0:
		animation = "proj_down"
	elif player.rangedTarget.y < 0:
		animation = "proj_up"
