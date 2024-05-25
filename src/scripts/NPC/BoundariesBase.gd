# BoundariesBase.gd
extends Node

signal boundary_hit(character, boundary_direction)

@export var min_x = 5
@export var max_x = 650
@export var min_y = 5
@export var max_y = 675

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
	var boundary_direction = Vector2()
	
	if pos.x < min_x:
		boundary_direction = Vector2(1, 0)  # Hit left boundary, move right
	elif pos.x > max_x:
		boundary_direction = Vector2(-1, 0)  # Hit right boundary, move left
	elif pos.y < min_y:
		boundary_direction = Vector2(0, 1)  # Hit bottom boundary, move up
	elif pos.y > max_y:
		boundary_direction = Vector2(0, -1)  # Hit top boundary, move down

	if boundary_direction != Vector2():
		print("Emitting boundary_hit signal for ", character.name, " with direction ", boundary_direction)
		emit_signal("boundary_hit", character, boundary_direction)
	
	pos.x = clamp(pos.x, min_x, max_x)
	pos.y = clamp(pos.y, min_y, max_y)
	character.global_position = pos
