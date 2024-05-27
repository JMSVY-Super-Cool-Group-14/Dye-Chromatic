extends Area2D

# Default configurations set based on node names
var new_camera_bounds: Rect2
var new_player_bounds: Rect2
var teleport_target_path: NodePath

# Dynamic node references
@onready var player: CharacterBody2D = get_node("/root/Game/Areas/Global/Player")
@onready var camera: Camera2D = get_node("/root/Game/Areas/Global/Player/PlayerCam")
@onready var player_boundaries: Node = get_node("/root/Game/Areas/Global/Player/PlayerBoundaries")
@onready var teleport_position_node: Node2D
@onready var fsm:FiniteStateMachine = get_node("/root/Game/FiniteStateMachine")

func _ready():
	# Configure teleporters based on their unique names
	if name == "TeleportToBoss":
		new_camera_bounds = Rect2(Vector2(0, 2400), Vector2(1674, 2400 + 1401))
		new_player_bounds = Rect2(Vector2(10, 2410), Vector2(1664, 2410 + 1401))
		teleport_target_path = "BossAreaToBoss/PositionBoss"
	elif name == "TeleportToBossArea":
		new_camera_bounds = Rect2(Vector2(0, 800), Vector2(1817*0.5, 735))
		new_player_bounds = Rect2(Vector2(10, 810*0.5), Vector2(1807*0.5, 810 + 300))
		teleport_target_path = "BaseToBossArea/PositionBossArea"

	teleport_position_node = get_node(teleport_target_path)
	connect("area_entered", Callable(self, "_on_area_entered"))
	print("Teleporter ready with default settings, waiting for player to enter...")

func _on_area_entered(area):
	if area.is_in_group("player"):
		print("Player detected in teleporter area")
		player.teleport(teleport_position_node.global_position)
		camera.update_bounds(new_camera_bounds)
		player_boundaries.update_bounds(new_player_bounds)
		print("Teleporter activated: Player teleported and boundaries updated")
		
		# Set fsm
		fsm.set_area(teleport_position_node.name)
	else:
		print("Non-player area entered teleporter")
