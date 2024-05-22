extends Area2D

var velocity = Vector2.ZERO
var speed = 100
var range = 170
var start_pos = Vector2.ZERO
var damage = 0
var pos
var start = false
# Called when the node enters the scene tree for the first time.
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
	velocity = direction.normalized() * speed
	
func _on_area_entered(area):
	if area.is_in_group("player"):
		area.take_fixed_damage(damage)
