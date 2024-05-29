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

func _ready():
	player = get_node_or_null(player_path) as CharacterBody2D
	if not player:
		push_error("Player node is not of type CharacterBody2D.")
		return

	background = get_node_or_null(texture_rect_path) as TextureRect
	if not background:
		push_error("Background node is not of type TextureRect.")
		return

	init_camera_settings()
	make_current()
	update_camera_limits()

func _physics_process(delta):
	if not player:
		return

	if centered_on_player:
		handle_camera_movement(delta)
	else:
		manual_camera_control(delta)

	handle_zoom(delta)

	if Input.is_action_just_pressed("reset_camera"):
		reset_camera()

	check_for_player_movement()

func init_camera_settings():
	zoom = DEFAULT_ZOOM
	global_position = player.global_position
	print("Camera initialized with zoom: ", zoom, " and position: ", global_position)

func handle_camera_movement(delta):
	if smoothing_enabled:
		global_position = global_position.lerp(player.global_position, smoothing_speed * delta)
	else:
		global_position = player.global_position

func manual_camera_control(delta):
	var movement_speed = 100
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

func reset_camera():
	zoom = DEFAULT_ZOOM
	global_position = player.global_position
	centered_on_player = true
	print("Camera reset to default settings.")

func update_camera_limits():
	if not background or not background.texture:
		return

	var bg_texture_size = background.texture.get_size() * background.scale
	var bg_position = background.global_position

	limit_left = bg_position.x
	limit_right = bg_position.x + bg_texture_size.x
	limit_top = bg_position.y
	limit_bottom = bg_position.y + bg_texture_size.y

	print("Dynamic camera limits set to: ", limit_left, ", ", limit_right, ", ", limit_top, ", ", limit_bottom)

func check_for_player_movement():
	if (Input.is_action_pressed("move_camera_left") or
		Input.is_action_pressed("move_camera_right") or
		Input.is_action_pressed("move_camera_up") or
		Input.is_action_pressed("move_camera_down")):
		centered_on_player = false
	else:
		centered_on_player = true
