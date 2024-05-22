extends Area2D
class_name bossline

var line_velocity = Vector2.ZERO
var speed = 50
var range = 200
var start_pos = Vector2.ZERO
var damage = 1
var pos


var attack_type = "range"


# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = global_position
	pos = start_pos




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pos += line_velocity * delta
	# Can't iterate global_position because 
	# it also iterates with the player's position.
	# This allows projectiles movement to be independent
	self.global_position = pos

	if (global_position.distance_to(start_pos) > range):
		queue_free()
		
func set_direction(direction: Vector2):
	line_velocity = direction.normalized() * speed
	
func set_properties(atk_speed, atk_damge):
	speed = atk_speed
	damage = atk_damge

func _on_area_right_area_entered(area):
	if area.is_in_group("player"):
		area.take_fixed_damage(damage)

func _on_area_left_area_entered(area):
	if area.is_in_group("player"):
		area.take_fixed_damage(damage)
