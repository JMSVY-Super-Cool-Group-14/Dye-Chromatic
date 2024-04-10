extends Area2D

var projectile_velocity = Vector2.ZERO
var speed = 100
var range = 100
var start_pos = Vector2.ZERO
var damage = 50
var pos

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = global_position
	pos = start_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pos += projectile_velocity * delta
	# Can't iterate global_position because 
	# it also iterates with the player's position.
	# This allows projectiles movement to be independent
	global_position = pos
	if (global_position.distance_to(start_pos) > range):
		queue_free()
		
func set_direction(direction: Vector2):
	projectile_velocity = direction.normalized() * speed
	
func _on_body_entered(body):

	if body.is_in_group("enemy"):
		print("enemy hit!")
		# body.health -= damage
		queue_free()	#remove projectile instance
