extends Area2D

var enemy
@export var duration = 7

# Called when the node enters the scene tree for the first time.
func _ready():
	lifespan()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if enemy != null:
		self.global_position = enemy.global_position
	else:
		queue_free()
	
	
func lifespan():
	await get_tree().create_timer(duration).timeout
	queue_free()

func set_size():
	if enemy.is_in_group("boss"):
		self.global_scale *= 1
	else:
		self.global_scale *= 0.1
