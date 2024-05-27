extends StaticBody2D

signal player_hit_impassable

func _ready():
	add_to_group("impassable")
	for child in get_children():
		if child is CollisionPolygon2D:
			child.add_to_group("impassable")
			# Connect to body_entered signal of the child
			child.connect("body_entered", Callable(self, "_on_body_entered"))
	print("Impassable object setup with ", get_child_count(), " children.")

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("player_hit_impassable")
