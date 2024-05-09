extends Area2D
class_name projectile

var projectile_velocity = Vector2.ZERO
var speed = 200
var range = 100
var start_pos = Vector2.ZERO
var damage = 30
var pos
var angle

@onready var fsm = $"../../FiniteStateMachine"
var attack_type = "range"


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
	self.global_rotation = direction.angle()
	projectile_velocity = direction.normalized() * speed
	
func _on_body_entered(body):

	if body.is_in_group("enemy"):
		if fsm.get_controller():
			Input.start_joy_vibration(0, 1, 1, 0.15)
		print("enemy hit!")
		# insert call to enemy take damage function
		body.fsm.take_damage(damage)
		body.recieve_knockeback(projectile_velocity, damage, attack_type)
		queue_free()	#remove projectile instance

	elif body.is_in_group("player"):
		print("player hit")
		body.take_fixed_damage(damage)
		queue_free()

func set_colour(colour: Color):
	$Sprite2D.self_modulate = colour
