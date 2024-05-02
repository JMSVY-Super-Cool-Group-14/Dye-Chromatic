extends CharacterBody2D
class_name enemy

@export var fsm : FiniteStateMachine



func recieve_knockeback(source_pos: Vector2, dmg, attack_type):	
	
	var knockback_dir = source_pos.direction_to(self.global_position)
	var knockback_strength = 0.1 * dmg
	var knockback = knockback_dir * knockback_strength
	
	if attack_type == "wave":
		print("Wave attack")
		knockback = knockback_dir * 6
		fsm._change_state($"State Machine/Stun")
	global_position += knockback
	if attack_type == "melee":
		fsm._change_state($"State Machine/Stun")
	

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
		$AnimatedSprite2D.play("Walk")
	
	else:
		$AnimatedSprite2D.play("Idle")
	
func _on_state_machine_took_dmg():
	$AnimatedSprite2D/damage.play("damage")
