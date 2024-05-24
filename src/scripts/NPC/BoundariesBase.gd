extends Node

@export var min_x = 0
@export var max_x = 658
@export var min_y = -1
@export var max_y = 682

func _process(delta):
	# Recursively ensure all CharacterBody2D descendants are clamped
	clamp_children(self)

func clamp_children(node):
	for child in node.get_children():
		if "CharacterBody2D" in child.get_class():  # Checks if child is a CharacterBody2D or any subclass thereof
			clamp_position(child)
		clamp_children(child)  # Recursive call to process all deeper children

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
