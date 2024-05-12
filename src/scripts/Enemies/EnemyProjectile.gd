extends Area2D
class_name enemyProjectile

var projectile_velocity = Vector2.ZERO
var speed = 100
var range = 100
var start_pos = Vector2.ZERO
var damage = 2
var pos
var angle


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
	self.global_position = pos

	if (global_position.distance_to(start_pos) > range):
		queue_free()
		
func set_direction(direction: Vector2):
	self.global_rotation = direction.angle()
	projectile_velocity = direction.normalized() * speed
	
func _on_body_entered(body):
	print(body.get_groups())
	if body.is_in_group("playera"):
		print("player hit")
		body.take_fixed_damage(damage)
		queue_free()


func set_colour(colour: Color):
	$Sprite2D.self_modulate = colour

func _on_area_entered(area):
	print(area.get_groups())
	if area.is_in_group("player"):
		print("player hit")
		area.take_fixed_damage(damage)
		queue_free()
