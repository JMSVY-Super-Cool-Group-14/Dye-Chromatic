extends Camera2D

var centered_on_player = true
@onready var player = get_parent()
var camera_speed = 100  # Speed at which the camera moves when arrow keys are pressed
var zoom_speed = 3  # Speed of zooming in and out
var min_zoom = Vector2(1.5, 1.5)  # Minimum zoom level
var max_zoom = Vector2(5, 5)  # Maximum zoom level
var last_player_position = Vector2()  # To track player's last position

func _ready():
	last_player_position = player.position  # Initialize with the player's initial position

func _process(delta):
	# Check player movement
	var player_moved = player.position != last_player_position
	if player_moved:
		centered_on_player = true

	# Determine if any camera movement keys are pressed
	var is_moving_camera = Input.is_action_pressed("move_camera_right") or \
						   Input.is_action_pressed("move_camera_left") or \
						   Input.is_action_pressed("move_camera_up") or \
						   Input.is_action_pressed("move_camera_down")

	# Unlock camera when moving it
	if is_moving_camera:
		centered_on_player = false

	if centered_on_player:
		# The camera will follow the player without manual input
		global_position = player.position
	else:
		# Move the camera according to inputs
		if Input.is_action_pressed("move_camera_right"):
			global_position.x += camera_speed * delta
		if Input.is_action_pressed("move_camera_left"):
			global_position.x -= camera_speed * delta
		if Input.is_action_pressed("move_camera_up"):
			global_position.y -= camera_speed * delta
		if Input.is_action_pressed("move_camera_down"):
			global_position.y += camera_speed * delta

	# Update the last player position at the end of the frame
	last_player_position = player.position

	# Handle zooming in and out
	if Input.is_action_pressed("zoom_in"):
		zoom -= Vector2(zoom_speed, zoom_speed) * delta
		zoom.x = max(zoom.x, min_zoom.x)
		zoom.y = max(zoom.y, min_zoom.y)
	if Input.is_action_pressed("zoom_out"):
		zoom += Vector2(zoom_speed, zoom_speed) * delta
		zoom.x = min(zoom.x, max_zoom.x)
		zoom.y = min(zoom.y, max_zoom.y)
