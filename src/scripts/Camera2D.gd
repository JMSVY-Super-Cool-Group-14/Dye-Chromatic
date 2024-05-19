extends Camera2D

@export var centered_on_player = true
@onready var player: Area2D = get_parent()  # Assuming Camera2D is a direct child of Player
@export var camera_speed = 100  # Speed at which the camera moves when arrow keys are pressed
@export var zoom_speed = 3  # Speed of zooming in and out
@export var min_zoom = Vector2(1.5, 1.5)  # Minimum zoom level
@export var max_zoom = Vector2(3, 3)  # Maximum zoom level
var last_player_position = Vector2()  # To track player's last position

# Standard Camera Settings
@export var DEFAULT_ZOOM = Vector2(2.5, 2.5)
@export var DEFAULT_POSITION = Vector2()

@export var smoothing_enabled = true
@export var smoothing_speed = 5.0

func _ready():
	player = get_parent()  # Ensure player is the parent node
	if not player:
		push_error("Player node not found as parent.")
		return
	last_player_position = player.position  # Initialize with the player's initial position
	zoom = DEFAULT_ZOOM  # Set the initial zoom level to default
	make_current()  # Make this camera the current camera
	set_limits()  # Set the camera limits
	global_position = player.global_position  # Ensure the camera starts centered on the player

func _process(delta):
	if not player:
		return
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
		if smoothing_enabled:
			global_position = lerp(global_position, player.global_position, smoothing_speed * delta)
		else:
			global_position = player.global_position
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

	# Handle zooming in and out
	if Input.is_action_pressed("zoom_in"):
		zoom -= Vector2(zoom_speed, zoom_speed) * delta
		zoom.x = max(zoom.x, min_zoom.x)
		zoom.y = max(zoom.y, min_zoom.y)
	if Input.is_action_pressed("zoom_out"):
		zoom += Vector2(zoom_speed, zoom_speed) * delta
		zoom.x = min(zoom.x, max_zoom.x)
		zoom.y = min(zoom.y, max_zoom.y)

	# Reset camera to default settings when "c" is pressed
	if Input.is_action_just_pressed("reset_camera"):
		zoom = DEFAULT_ZOOM
		global_position = player.position

	# Update the last player position at the end of the frame
	last_player_position = player.position

func set_limits():
	limit_left = -1000
	limit_right = 1000
	limit_top = -1000
	limit_bottom = 1000
