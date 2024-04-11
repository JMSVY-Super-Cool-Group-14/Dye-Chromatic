extends Area2D

var start_pos
var teleport_range = 50
var lifespan = 0.2
var time_passed = 0
@onready var player = $"../"
# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_passed += delta
	if time_passed > lifespan:
		queue_free()
	
	
func teleport(direction):
	player.global_position += direction * teleport_range
	
