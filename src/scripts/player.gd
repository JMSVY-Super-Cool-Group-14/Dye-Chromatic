extends Area2D

var DELAY = 0.25
var maxHP = 100
var hp = 10
var hpRegen = 5
var hpRegenDelay = 10
var timePassed = 0
var attackDelta = 0
var meleeRange = 22
var velocity = Vector2.ZERO
var colourWheel = {
	"grey" : Color(0, 0, 0),
	"red" : Color(1, 0, 0),
	"green" : Color(0, 1, 0),
	"blue" : Color(0, 0, 1),
	"yellow" : Color(1, 1, 0),
	"magenta" : Color(1, 0, 1), 
	"cyan" : Color(0, 1, 1)
		}
@onready var leftColour = "blue"
@onready var rightColour = "red"
@onready var colourCombined = "magenta"
@onready var currentColour = "grey"
@onready var leftActivated = false
@onready var rightActivated = false
@onready var rangedTarget = Vector2.ZERO
@onready var facingDirection = Vector2(0, 1)
@export var speed = 100
@onready var fsm = $"../FiniteStateMachine"
var melee_scene = preload("res://scenes/attacks/meleeAttack.tscn")
var projectile_scene = preload("res://scenes/attacks/projectile.tscn")
var special_magenta_scene = preload("res://scenes/attacks/special_magenta.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.play()
	attackDelta += delta
	timePassed += delta
	
	if timePassed > hpRegenDelay and hp < maxHP:
		print("Regenerate health! Health is: ")
		print(hp)
		hp += hpRegen
		timePassed = 0
	
	
	# Movement
	if fsm.get_controller():
		velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		rangedTarget = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	else:
		key_move()
	
	#Colour Control
	leftActivated = Input.is_action_pressed("left_colour")
	rightActivated = Input.is_action_pressed("right_colour")
	set_colour(leftActivated, rightActivated)
	
	# Facing direction check
	if velocity.length() <= 0:
		pass
	else:
		facingDirection = velocity
	
	# Actual moving of object
	position += velocity * delta * speed
	position = position.clamp(Vector2.ZERO, get_viewport_rect().size)
	
func start(pos):
	position = pos
	show()

func key_move():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
func _input(event):
	
	# Add colour select options here
	# AKA to change which two colours 
	# you have equipped
	
	# #####################
	
	if attackDelta > DELAY:
		if fsm.get_controller():
			if event.is_action_pressed("ranged_attack") and rangedTarget!=Vector2.ZERO:
				fire_projectile(rangedTarget, currentColour)
				attackDelta = 0
			elif event.is_action("melee_attack"):
				melee_attack(currentColour)
				attackDelta = 0
			elif event.is_action_pressed("special_attack"):
				colour_special()

		else:
			if event.is_action_pressed("ranged_attack"):
				var mouse_pos = get_global_mouse_position()
				fire_projectile(mouse_pos, currentColour)
				attackDelta = 0
			elif event.is_action_pressed("melee_attack"):
				melee_attack(currentColour)
				attackDelta = 0
			elif event.is_action_pressed("special_attack"):
				colour_special()
			
func fire_projectile(target_pos: Vector2, colour: String):
	print("attempting ranged " + colour)
	var projectile = projectile_scene.instantiate()
	add_child(projectile)
	projectile.set_colour(colourWheel[colour])
	projectile.global_position = global_position
	slow(0.7, 0.1)
	if fsm.get_controller():
		projectile.set_direction(target_pos)
	else:
		var direction = (target_pos - global_position).normalized()
		projectile.set_direction(direction)
	
func melee_attack(colour: String):
	print("attempting melee " + colour)
	var melee_strike = melee_scene.instantiate()
	add_child(melee_strike)
	slow(0.9, 0.3)
	melee_strike.set_angle(facingDirection)
	melee_strike.set_colour(colourWheel[colour])
	melee_strike.global_position = global_position + facingDirection.normalized()*meleeRange
	
func set_colour(left, right):
	if left and right:
		currentColour = colourCombined
	elif left:
		currentColour = leftColour
	elif right:
		currentColour = rightColour
	else:
		currentColour = "grey"
		
func colour_special():
	match currentColour:
		"grey":
			print("greySpecial")
		"red":
			print("redSpecial")
		"green":
			print("greenSpecial")
		"blue":
			print("blueSpecial")
		"yellow":
			print("yellowSpecial")
		"magenta":
			var magenta_special = special_magenta_scene.instantiate()
			add_child(magenta_special)
			magenta_special.teleport(facingDirection)
		"cyan":
			print("cyanSpecial")

func slow(slow_amount: float, slow_duration: float):
	var original_speed = speed
	speed = speed * abs(1 - slow_amount)
	await get_tree().create_timer(slow_duration).timeout
	speed = original_speed

func take_fixed_damage(damage: int):
	hp -= damage

func take_DOT_damage(damage: float, duration: float):
	var tick = damage / duration
	for n in range(0, damage, tick):
		hp -= tick
