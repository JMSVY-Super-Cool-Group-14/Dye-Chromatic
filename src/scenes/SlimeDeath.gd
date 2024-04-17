extends State
class_name enemyDeath

@export var enemy : CharacterBody2D

		
func _enter_state():
	enemy.velocity = Vector2.ZERO
	
func _state_update(delta : float):
	pass
		
func _state_physics_update(delta : float):
	pass
