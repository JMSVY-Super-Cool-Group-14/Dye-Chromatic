# Teleporter.gd
extends Area2D

@export var new_camera_bounds = Rect2(Vector2(0, 800), Vector2(1817, 800 + 1469))
@export var new_player_bounds = Rect2(Vector2(10, 810), Vector2(1807, 790 + 1469))  # Custom values for player bounds

@onready var player: Area2D
@onready var camera: Camera2D
@onready var player_boundaries: Node
@onready var teleport_position_node: Node2D

func _ready():
	# Adjust the paths to the nodes based on the new hierarchy
	player = get_node("/root/Game/Areas/Global/Player")
	camera = get_node("/root/Game/Areas/Global/Player/PlayerCam")
	player_boundaries = get_node("/root/Game/Areas/Global/Player/PlayerBoundaries")
	teleport_position_node = $BaseToBossArea/PositionBossArea

	# Connect the area_entered signal to the _on_area_entered function
	connect("area_entered", Callable(self, "_on_area_entered"))
	
	print("Teleporter ready, waiting for player to enter...")

func _on_area_entered(area):
	print("area_entered signal received with area: ", area)
	if area.is_in_group("player"):
		print("Player detected in teleporter area")
		player.teleport(teleport_position_node.global_position)
		camera.update_bounds(new_camera_bounds)
		player_boundaries.update_bounds(new_player_bounds)
		print("Teleporter activated: Player teleported and boundaries updated")
	else:
		print("Non-player area entered teleporter")
