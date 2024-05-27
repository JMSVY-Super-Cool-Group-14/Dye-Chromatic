extends Node

@export var min_x = 10
@export var max_x = 648.4
@export var min_y = 10
@export var max_y = 674

func _ready():
	# Initialize boundaries to ensure they are set from script values
	print("Initial player boundaries: ", min_x, max_x, min_y, max_y)
	clamp_player_position()

func clamp_player_position():
	var player_position = get_parent().position
	player_position.x = clamp(player_position.x, min_x, max_x)
	player_position.y = clamp(player_position.y, min_y, max_y)
	get_parent().position = player_position
	print("Player position after clamping: ", player_position)

func update_bounds(new_bounds: Rect2):
	min_x = new_bounds.position.x
	max_x = new_bounds.position.x + new_bounds.size.x
	min_y = new_bounds.position.y
	max_y = new_bounds.position.y + new_bounds.size.y
	print("Player boundaries updated to: ", min_x, max_x, min_y, max_y)
	clamp_player_position()
