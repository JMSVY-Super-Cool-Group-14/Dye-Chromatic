extends CharacterBody2D
class_name enemy

@export var fsm : FiniteStateMachine



func recieve_knockeback(source_pos: Vector2, dmg):
	var knockback_dir = source_pos.direction_to(self.global_position)
	var knockback_strength = 0.1 * dmg
	var knockback = knockback_dir * knockback_strength
	
	global_position += knockback

func _physics_process(delta):
	move_and_slide()
	if fsm.health <= 0:
		self.velocity = Vector2.ZERO
		$AnimatedSprite2D.play("Death")
		if $AnimatedSprite2D.frame == 4:
			queue_free()
	elif fsm.current_state == fsm.get_child(2):
		$AnimatedSprite2D.play("Idle")
	elif velocity.length() > 0:
		$AnimatedSprite2D.play("walk")
	
	else:
		$AnimatedSprite2D.play("Idle")
	
	

