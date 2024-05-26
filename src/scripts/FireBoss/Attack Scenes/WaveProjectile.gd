extends Area2D
class_name bossProjectile

var projectile_velocity = Vector2.ZERO
var speed = 10
var start_pos
var damage = 0
var angle
var player
var exited = false
var range = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $"../../Areas/Global/Player"
	start_pos = global_position
	get_tree().create_timer(5).timeout.connect(func(): range = true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	update_direction_to_player()
	global_position += projectile_velocity * delta

	if range:
		queue_free()

func set_properties(atk_speed, atk_damge, orb_scale=Vector2(1,1)):
	speed = atk_speed
	damage = atk_damge
	self.scale *= orb_scale
		
func set_direction(direction: Vector2):
	self.global_rotation = direction.angle() - PI/2
	projectile_velocity = direction.normalized() * speed

func update_direction_to_player():
	var direction = player.global_position - self.global_position
	set_direction(direction)
	
func _on_area_entered(area):
	if area.is_in_group("player"):
		area.take_fixed_damage(damage)
		queue_free()



func _on_body_entered(body):
	if body.is_in_group("boss") and exited:
		body.fsm.take_damage(damage, "orb")
		queue_free()


func _on_body_exited(body):
	if body.is_in_group("boss"):
		exited = true
