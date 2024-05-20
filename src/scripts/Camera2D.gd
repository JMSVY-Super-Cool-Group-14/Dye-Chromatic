extends Camera2D

var centered_on_player = true
@onready var player = get_parent()
var camera_speed = 100  # Speed at which the camera moves when arrow keys are pressed
var zoom_speed = 3  # Speed of zooming in and out
var min_zoom = Vector2(3, 3)  # Minimum zoom level
var max_zoom = Vector2(5, 5)  # Maximum zoom level
var last_player_position = Vector2()  # To track player's last position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
