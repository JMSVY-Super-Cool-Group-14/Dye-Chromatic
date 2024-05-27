# Camera2D.gd
extends Camera2D

@export var centered_on_player = true
@export var player_path: NodePath  # Path to the player node
@export var camera_speed = 100
@export var zoom_speed = 3
@export var min_zoom = Vector2(1.5, 1.5)
@export var max_zoom = Vector2(3, 3)
var last_player_position = Vector2()
var player: CharacterBody2D

# Standard Camera Settings
@export var DEFAULT_ZOOM = Vector2(2.5, 2.5)
@export var DEFAULT_POSITION = Vector2()

@export var smoothing_enabled = true
@export var smoothing_speed = 5.0

func _ready():
	if player_path:
		player = get_node(player_path) as CharacterBody2D
	else:
		push_error("Player node path is not set.")
		return

	last_player_position = player.position
	zoom = DEFAULT_ZOOM
	make_current()
	global_position = player.global_position

	# Initialize limits to ensure they are set from script values
	set_limits(0, 658.4, 0, 684)

func _process(delta):
	if not player:
		return

	var player_moved = player.position != last_player_position
	if player_moved:
		centered_on_player = true

	var is_moving_camera = Input.is_action_pressed("move_camera_right") or \
						   Input.is_action_pressed("move_camera_left") or \
						   Input.is_action_pressed("move_camera_up") or \
						   Input.is_action_pressed("move_camera_down")

	if is_moving_camera:
		centered_on_player = false

	if centered_on_player:
		if smoothing_enabled:
			global_position = global_position.lerp(player.global_position, smoothing_speed * delta)
		else:
			global_position = player.global_position
	else:
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

	if Input.is_action_just_pressed("reset_camera"):
		zoom = DEFAULT_ZOOM
		global_position = player.position

	last_player_position = player.position

func set_limits(left: int, right: int, top: int, bottom: int):
	limit_left = left
	limit_right = right
	limit_top = top
	limit_bottom = bottom
	print("Camera limits set to: ", left, right, top, bottom)

func update_bounds(new_bounds: Rect2):
	set_limits(new_bounds.position.x, new_bounds.position.x + new_bounds.size.x, new_bounds.position.y, new_bounds.position.y + new_bounds.size.y)
	print("Camera bounds updated to: ", limit_left, limit_right, limit_top, limit_bottom)
