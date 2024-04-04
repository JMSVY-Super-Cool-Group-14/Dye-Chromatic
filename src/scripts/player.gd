extends Area2D

var velocity
@export var speed = 100
@onready var fsm = $"../FiniteStateMachine"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.play()
	
	if fsm.get_controller():
		velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	else:
		key_move()
	
	if velocity.length() <= 0:
		$AnimatedSprite2D.animation = "idle"
	
	position += velocity * delta * speed
	position = position.clamp(Vector2.ZERO, get_viewport_rect().size)
	
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
	print("Keys velocity:", velocity)
