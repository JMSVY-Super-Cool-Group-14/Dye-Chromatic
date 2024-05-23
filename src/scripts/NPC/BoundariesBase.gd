extends Node

@export var min_x = 10
@export var max_x = 810
@export var min_y = 15
@export var max_y = 800

func _process(delta):
	# Ensure all CharacterBody2D children are clamped within the defined boundaries
	for child in get_children():
		if child is CharacterBody2D:
			clamp_position(child)

func clamp_position(character):
	# Clamp the character's position within the defined boundaries
	var pos = character.global_position
	var original_pos = pos
	pos.x = clamp(pos.x, min_x, max_x)
	pos.y = clamp(pos.y, min_y, max_y)
	character.global_position = pos
	
	# Debug prints to verify clamping
	if pos != original_pos:
		print("Clamped position for ", character.name, " from ", original_pos, " to ", pos)
