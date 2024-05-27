extends State

func _enter_state():
	$"../..".velocity = Vector2.ZERO
	$"../../AnimatedSprite2D".play("Death")
