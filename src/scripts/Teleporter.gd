extends Area2D

# Export variables for setting bounds and paths in the Inspector
@export var new_camera_bounds: Rect2
@export var new_player_bounds: Rect2
@export var teleport_target_path: NodePath

# Dynamic references set once nodes are ready
@onready var player: CharacterBody2D = get_node("/root/Game/Player")
@onready var camera: Camera2D = get_node("/root/Game/Player/PlayerCam")
@onready var player_boundaries: Node2D = get_node("/root/Game/Player/PlayerBoundaries")
@onready var teleport_position_node: Marker2D = get_node_or_null(teleport_target_path) as Marker2D
@onready var fsm: FiniteStateMachine = get_node("/root/Game/FiniteStateMachine")

func _ready():
	configure_teleporters()
	if not teleport_position_node:
		push_error("Teleport position node not found: " + String(teleport_target_path))
		return
	connect("body_entered", Callable(self, "_on_body_entered"))
	print("Teleporter ready with default settings, waiting for player to enter...")

func configure_teleporters():
	# Configure teleporters based on their unique names
	match name:
		"TeleportToBoss":
			new_camera_bounds = Rect2(Vector2(0, 2400), Vector2(1674, 1401))
			new_player_bounds = Rect2(Vector2(10, 2410), Vector2(1664, 1391))
			teleport_target_path = "TeleportTarget"  # Adjust as per actual node name/path
		"TeleportToBossArea":
			new_camera_bounds = Rect2(Vector2(0, 800), Vector2(1817 * 0.5, 735))
			new_player_bounds = Rect2(Vector2(10, 810 * 0.5), Vector2(1807 * 0.5, 300))
			teleport_target_path = "TeleportTarget"
		"TeleportToHub":
			new_camera_bounds = Rect2(Vector2(0, 0), Vector2(1646*0.4, 1710*0.4))
			new_player_bounds = Rect2(Vector2(10, 10), Vector2(1636*0.4, 1700*0.4))
			teleport_target_path = "TeleportTarget"

func _on_body_entered(body):
	if body == player:
		print("Player detected in teleporter area")
		perform_teleportation()

func perform_teleportation():
	player.global_position = teleport_position_node.global_position
	update_camera_bounds(new_camera_bounds)
	update_player_bounds(new_player_bounds)
	fsm.set_area(teleport_position_node.name)
	print("Teleporter activated: Player teleported and boundaries updated")

func update_camera_bounds(bounds):
	camera.limit_left = bounds.position.x
	camera.limit_top = bounds.position.y
	camera.limit_right = bounds.position.x + bounds.size.x
	camera.limit_bottom = bounds.position.y + bounds.size.y
	print("Camera bounds updated to: ", camera.limit_left, ", ", camera.limit_top, ", ", camera.limit_right, ", ", camera.limit_bottom)

func update_player_bounds(bounds):
	player_boundaries.position = bounds.position
	player_boundaries.scale = bounds.size
	print("Player boundaries updated to: ", player_boundaries.position, " with scale: ", player_boundaries.scale)
