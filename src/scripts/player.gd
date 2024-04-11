extends Area2D

var DELAY = 0.25
var attackDelta = 0
var meleeRange = 30
var velocity
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
var isAttacking = false
var melee_scene = preload("res://scenes/attacks/meleeAttack.tscn")
var projectile_scene = preload("res://scenes/attacks/projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.play()
	attackDelta += delta
	
	# Movement
	if fsm.get_controller() && !isAttacking:
		velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		rangedTarget = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	elif !isAttacking:
		key_move()
	
	#Colour Control
	leftActivated = Input.is_action_pressed("left_colour")
	rightActivated = Input.is_action_pressed("right_colour")
	set_colour(leftActivated, rightActivated)
	
	# Idle animation and facing direction check
	if velocity.length() <= 0 && !isAttacking:
		$AnimatedSprite2D.animation = "idle"
	else:
		facingDirection = velocity
	
	# Actual moving of object
	position += velocity * delta * speed
	position = position.clamp(Vector2.ZERO, get_viewport_rect().size)
	
	# Walking animation
	if velocity.x > 0:
		$AnimatedSprite2D.animation = "walk_right"
	elif velocity.x < 0:
		$AnimatedSprite2D.animation = "walk_left"
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = "walk_down"
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "walk_up"
		
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

		else:
			if event.is_action_pressed("ranged_attack"):
				var mouse_pos = get_global_mouse_position()
				fire_projectile(mouse_pos, currentColour)
				attackDelta = 0

			elif event.is_action_pressed("melee_attack"):
				melee_attack(currentColour)
				attackDelta = 0
				
			
func fire_projectile(target_pos: Vector2, colour: String):
	print("attempting ranged " + colour)
	var projectile = projectile_scene.instantiate()
	add_child(projectile)
	projectile.set_colour(colourWheel[colour])
	projectile.global_position = global_position

	if fsm.get_controller():
		projectile.set_direction(target_pos)
	else:
		var direction = (target_pos - global_position).normalized()
		projectile.set_direction(direction)
	
func melee_attack(colour: String):
	print("attempting melee " + colour)
	var melee_strike = melee_scene.instantiate()
	add_child(melee_strike)
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
