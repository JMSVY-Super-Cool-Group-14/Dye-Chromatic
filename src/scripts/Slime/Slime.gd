extends CharacterBody2D
class_name Slime



func _physics_process(delta):
	move_and_slide()
	if velocity.length() > 0:
		$AnimatedSprite2D.play("walk")
	
	else:
		$AnimatedSprite2D.play("Idle")
	
