extends Area2D


var projectile_velocity = Vector2.ZERO
var speed = 100
var range = 400
var start_pos = Vector2.ZERO
var damage = 0
var pos
var angle

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

func set_properties(atk_speed, atk_damge, orb_scale=Vector2(1,1), start_position=Vector2.ZERO):
	speed = atk_speed
	damage = atk_damge
	self.scale *= orb_scale
	start_pos = start_position
	pos = start_pos
		
func set_direction(direction: Vector2):
	self.global_rotation = direction.angle() - PI/2
	projectile_velocity = direction.normalized() * speed
	
func _on_area_entered(area):
	if area.is_in_group("player"):
		area.take_fixed_damage(damage)
		queue_free()
