extends Area2D

signal player_collided

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("player_collided", body)
		print("Player collided with static body: ", body)
