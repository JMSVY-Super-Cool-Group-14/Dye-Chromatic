extends CharacterBody2D
class_name Slime

@export var health := 100

func take_damage(dmg):
	health -= dmg

func _physics_process(delta):
	move_and_slide()
	if health <= 0:
		$AnimatedSprite2D.play("Death")
		if $AnimatedSprite2D.frame == 4:
			queue_free()
	elif velocity.length() > 0:
		$AnimatedSprite2D.play("walk")
	
	else:
		$AnimatedSprite2D.play("Idle")
	
	

