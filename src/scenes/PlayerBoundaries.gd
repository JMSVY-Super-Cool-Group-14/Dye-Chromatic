extends Node

@export var min_x = 0
@export var max_x = 658
@export var min_y = -1
@export var max_y = 682

func _process(delta):
	# Ensure the player's position is clamped within the defined boundaries
	var player_position = get_parent().position
	player_position.x = clamp(player_position.x, min_x, max_x)
	player_position.y = clamp(player_position.y, min_y, max_y)
	get_parent().position = player_position