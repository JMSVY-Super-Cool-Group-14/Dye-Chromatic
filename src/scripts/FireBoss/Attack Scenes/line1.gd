extends Area2D
class_name bossLine

var line_velocity = Vector2.ZERO
var speed = 50
var range = 900

var start_pos
var damage = 1
var pos


# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = global_position




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	global_position += line_velocity * delta


	if (global_position.distance_to(start_pos) > range):
		queue_free()
		
func set_direction(direction: Vector2):
	line_velocity = direction.normalized() * speed
	
func set_properties(atk_speed, atk_damge):
	speed = atk_speed
	damage = atk_damge

func _physics_process(delta):
	$AreaLeft/AnimatedSprite2D.play("default")
	$AreaRight/AnimatedSprite2D.play("default")
	$AreaMiddle/AnimatedSprite2D.play("default")

func _on_area_right_area_entered(area):
	if area.is_in_group("player"):
		area.take_fixed_damage(damage)

func _on_area_left_area_entered(area):
	if area.is_in_group("player"):
		area.take_fixed_damage(damage)

func _on_area_middle_area_entered(area):
	if area.is_in_group("player"):
		area.take_fixed_damage(damage)
