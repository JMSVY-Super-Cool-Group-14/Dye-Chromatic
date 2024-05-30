extends Node

@export var texture_rect_path: NodePath = NodePath("/root/Game/Background")  # Path to the TextureRect node
@export var player_path: NodePath = NodePath("/root/Game/Player")  # Path to the Player node

# Define the boundaries with initial values
var min_x: float
var max_x: float
var min_y: float
var max_y: float

@onready var player: CharacterBody2D = get_node(player_path)  # Get the player node using the specified path
@onready var texture_rect: TextureRect = get_node(texture_rect_path)

@export var boundary_offset: float = 10.0  # Offset for the boundaries

func _ready():
	# Initialize boundaries based on the texture size
	update_bounds_from_texture()
	clamp_player_position()

func _process(delta: float) -> void:
	clamp_player_position()

func clamp_player_position() -> void:
	var player_position = player.global_position
	player_position.x = clamp(player_position.x, min_x, max_x)
	player_position.y = clamp(player_position.y, min_y, max_y)
	player.global_position = player_position

func update_bounds_from_texture() -> void:
	var texture_size = texture_rect.texture.get_size() * texture_rect.scale
	min_x = texture_rect.global_position.x + boundary_offset
	max_x = texture_rect.global_position.x + texture_size.x - boundary_offset
	min_y = texture_rect.global_position.y + boundary_offset
	max_y = texture_rect.global_position.y + texture_size.y - boundary_offset
	clamp_player_position()

func update_bounds(new_bounds: Rect2) -> void:
	min_x = new_bounds.position.x + boundary_offset
	max_x = new_bounds.position.x + new_bounds.size.x - boundary_offset
	min_y = new_bounds.position.y + boundary_offset
	max_y = new_bounds.position.y + new_bounds.size.y - boundary_offset
	clamp_player_position()
