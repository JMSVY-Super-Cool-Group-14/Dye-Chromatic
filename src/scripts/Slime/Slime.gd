extends CharacterBody2D
class_name Slime

@export var health := 100

func take_dmg(dmg):
	health -= dmg

func _physics_process(delta):
	move_and_slide()
	if velocity.length() > 0:
		$AnimatedSprite2D.play("walk")
	
	else:
		$AnimatedSprite2D.play("Idle")
	

