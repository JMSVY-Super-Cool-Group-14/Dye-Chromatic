extends Camera2D

var centered_on_player = true
var character_position = Vector2()  # This will store the character's position
var map_bounds = Rect2(0, 0, 7, 7)  # The game world boundaries
@onready var player = get_parent()
var camera_speed = 100  # Speed at which the camera moves when arrow keys are pressed
var zoom_speed = 10  # Speed of zooming in and out
var min_zoom = Vector2(3, 3)  # Minimum zoom level
var max_zoom = Vector2(20, 20)  # Maximum zoom level
var base_zoom = Vector2(5, 5)

func _ready():
	zoom = Vector2(5, 5)  # Start with a basic zoom level

func _process(delta):
	character_position = player.position  # Update the character's position from the player node
	var target_position = global_position  # Start with the current global position of the camera

	# Handle camera movement with arrow keys
	if Input.is_action_pressed("ui_right"):
		target_position.x += camera_speed * delta
	if Input.is_action_pressed("ui_left"):
		target_position.x -= camera_speed * delta
	if Input.is_action_pressed("ui_up"):
		target_position.y -= camera_speed * delta
	if Input.is_action_pressed("ui_down"):
		target_position.y += camera_speed * delta

	# Handle zooming in and out
	if Input.is_action_pressed("zoom_in"):  # Assuming 'z' is mapped to 'ui_zoom_in'
		zoom -= Vector2(zoom_speed, zoom_speed) * delta
		zoom.x = max(zoom.x, min_zoom.x)
		zoom.y = max(zoom.y, min_zoom.y)
	if Input.is_action_pressed("zoom_out"):  # Assuming 'x' is mapped to 'ui_zoom_out'
		zoom += Vector2(zoom_speed, zoom_speed) * delta
		zoom.x = min(zoom.x, max_zoom.x)
		zoom.y = min(zoom.y, max_zoom.y)

	# Calculate how much of the world the camera sees relative to the base zoom level.
	# Since higher zoom values mean we see less of the world, we divide the base zoom by the current zoom.
	var viewable_area_factor = base_zoom / zoom

	# Calculate the difference in viewable area at the current zoom level compared to the base zoom.
	# This difference needs to be considered in the clamping to maintain the same boundaries of view.
	var viewable_area_diff_x = (map_bounds.size.x - (6 * 32)) * (1 - viewable_area_factor.x)
	var viewable_area_diff_y = (map_bounds.size.y - (5 * 32)) * (1 - viewable_area_factor.y)

	# Clamp the target position, subtracting the difference in viewable area to adjust the clamping boundary.
	target_position.x = clamp(target_position.x, 3 * 32, (9 * 32) - viewable_area_diff_x)
	target_position.y = clamp(target_position.y, 2 * 32, (7 * 32) - viewable_area_diff_y)


	global_position = target_position  # Update the camera position based on input

	if centered_on_player:
		# Reset to player position if still centered on player
		if player.key_move():  # Assuming your player script has a 'key_move' method
			global_position = Vector2(clamp(player.position.x, 3 * 32, 9 * 32),
									  clamp(player.position.y, 2 * 32, 7 * 32))

