extends Area2D
class_name bossMeleeScene

var velocity = Vector2.ZERO
var speed = 100
var range = 200
var start_pos
var damage = 50
var pos
var start = false


func _ready():
	start_pos = global_position
	pos = start_pos
	
	get_tree().create_timer(0.5).timeout.connect(func(): start = true)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	if start:
		pos += velocity * delta
		self.global_position = pos
		if (global_position.distance_to(start_pos) > range):
			queue_free()

func set_properties(atk_speed, atk_damge):
	speed = atk_speed
	damage = atk_damge
		
func set_direction(direction: Vector2):
	self.global_rotation = direction.angle() - PI
	velocity = direction.normalized() * speed
	
	
func _on_area_entered(area):
	if area.is_in_group("player"):
		area.take_fixed_damage(damage)
