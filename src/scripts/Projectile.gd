extends Area2D

var velocity = Vector2.ZERO
var speed = 100
var range = 100
var start_pos = Vector2.ZERO
var damage = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	global_position += velocity * delta
	if (global_position.distance_to(start_pos) > range):
		queue_free()
		
func set_direction(direction: Vector2):
	velocity = direction.normalized() * speed
	
func _on_body_entered(body):

	if body.is_in_group("enemy"):
		print("enemy hit!")
		# body.health -= damage
		queue_free()	#remove projectile instance
