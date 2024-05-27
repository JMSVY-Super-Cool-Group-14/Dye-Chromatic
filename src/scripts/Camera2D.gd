extends Camera2D

@export var DEFAULT_ZOOM := Vector2(2.5, 2.5)
@export var zoom_speed := 3.0
@export var min_zoom := Vector2(1.5, 1.5)
@export var max_zoom := Vector2(3.0, 3.0)
@export var smoothing_enabled := true
@export var smoothing_speed := 5.0

@export var texture_rect_path: NodePath = NodePath("/root/Game/Background")
@export var player_path: NodePath = NodePath("/root/Game/Areas/Global/Player")

var player: CharacterBody2D
var background: TextureRect
var centered_on_player := true
var last_player_position := Vector2.ZERO

func _ready():
	player = get_node(player_path) as CharacterBody2D
	if not player:
		push_error("Player node is not of type CharacterBody2D.")
		return
	
	background = get_node(texture_rect_path) as TextureRect
	if not background:
		push_error("Background node is not of type TextureRect.")
		return

	set_default_zoom()
	make_current()
	set_background_limits()

func _process(delta):
	if not player:
		return

	# Check for manual movement
	if (Input.is_action_pressed("move_camera_left") or 
		Input.is_action_pressed("move_camera_right") or 
		Input.is_action_pressed("move_camera_up") or 
		Input.is_action_pressed("move_camera_down")):
		centered_on_player = false
	else:
		centered_on_player = true

	# If centered on player, follow player
	if centered_on_player:
		if smoothing_enabled:
			global_position = global_position.lerp(player.global_position, smoothing_speed * delta)
		else:
			global_position = player.global_position
	else:
		handle_manual_camera_movement(delta)

	handle_zoom(delta)

	if Input.is_action_just_pressed("reset_camera"):
		set_default_zoom()
		centered_on_player = true  # Re-center the camera on the player when resetting

	last_player_position = player.global_position

func handle_manual_camera_movement(delta):
	var movement_speed = 100  # Adjust as needed
	if Input.is_action_pressed("move_camera_left"):
		global_position.x -= movement_speed * delta
	if Input.is_action_pressed("move_camera_right"):
		global_position.x += movement_speed * delta
	if Input.is_action_pressed("move_camera_up"):
		global_position.y -= movement_speed * delta
	if Input.is_action_pressed("move_camera_down"):
		global_position.y += movement_speed * delta

func handle_zoom(delta):
	if Input.is_action_pressed("zoom_in"):
		zoom -= Vector2(zoom_speed, zoom_speed) * delta
		zoom.x = max(zoom.x, min_zoom.x)
		zoom.y = max(zoom.y, min_zoom.y)
	if Input.is_action_pressed("zoom_out"):
		zoom += Vector2(zoom_speed, zoom_speed) * delta
		zoom.x = min(zoom.x, max_zoom.x)
		zoom.y = min(zoom.y, max_zoom.y)

func set_default_zoom():
	zoom = DEFAULT_ZOOM
	if player:
		global_position = player.global_position
	print("Default zoom set to: ", zoom)
	print("Default position set to: ", global_position)

func set_background_limits():
	if not background or not background.texture:
		return

	var bg_texture_size = background.texture.get_size()
	var bg_scale = background.scale

	limit_left = 0
	limit_right = bg_texture_size.x * bg_scale.x
	limit_top = 0
	limit_bottom = bg_texture_size.y * bg_scale.y

	print("Camera limits set to: ", limit_left, limit_right, limit_top, limit_bottom)
