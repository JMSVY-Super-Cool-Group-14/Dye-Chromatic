extends Camera2D

var zoom_speed = 1  # Adjusted for finer control
var movement_speed = 500  # Pixels per second
var min_zoom = Vector2(0.5, 0.5)  # Closer to the character
var max_zoom = Vector2(2, 2)  # About 2x the normal view

# Called when the node enters the scene tree for the first time.
func _ready():
	zoom = Vector2(1, 1)  # Start with the default zoom level

func _process(delta):
	# Handle zooming
	if Input.is_action_pressed("zoom_in"):  # Zoom in with 'Z'
		zoom -= Vector2(zoom_speed, zoom_speed) * delta
	elif Input.is_action_pressed("zoom_out"):  # Zoom out with 'X'
		zoom += Vector2(zoom_speed, zoom_speed) * delta

	# Clamping the zoom level to avoid too much zoom in or out
	zoom.x = clamp(zoom.x, min_zoom.x, max_zoom.x)
	zoom.y = clamp(zoom.y, min_zoom.y, max_zoom.y)
	
	# Handle movement
	var movement = Vector2()
	if Input.is_action_pressed("ui_left"):  # Move left
		movement.x -= 1
	if Input.is_action_pressed("ui_right"):  # Move right
		movement.x += 1
	if Input.is_action_pressed("ui_up"):  # Move up
		movement.y -= 1
	if Input.is_action_pressed("ui_down"):  # Move down
		movement.y += 1
	
	# Normalize the movement to prevent faster diagonal movement
	movement = movement.normalized() * movement_speed
	
	# Apply the movement
	position += movement * delta
