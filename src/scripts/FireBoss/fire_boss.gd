extends CharacterBody2D
class_name boss

@export var fsm : FiniteStateMachine
@onready var stunState = $"State Machine/Stun"

func recieve_knockeback(source_pos: Vector2, dmg, attack_type):	
	
	var knockback_dir = source_pos.direction_to(self.global_position)
	var knockback_strength = 0.1 * dmg
	var knockback = knockback_dir * knockback_strength
	
	if attack_type == "blueSpecial":
		print("Wave attack")
		knockback = knockback_dir * 6
		fsm._change_state($"State Machine/Stun")
	elif attack_type == "melee":
		fsm._change_state($"State Machine/Stun")
	elif attack_type == "blueUlt":
		print("stunssssss")
		var originalStun = stunState.stun_time
		stunState.stun_time = 7
		fsm._change_state($"State Machine/Stun")
		stunState.stun_time = originalStun
	
	global_position += knockback

func _physics_process(delta):
	move_and_slide()
	if fsm.health <= 0:
		self.velocity = Vector2.ZERO
		$AnimatedSprite2D.play("Death")
		$AnimatedSprite2D.animation_finished.connect(free)
	if !fsm.phase3:
		$AnimatedSprite2D.play("Still_Pool")
	
	elif fsm.phase3 and fsm.current_state.name != "Death":
		if self.velocity.length() <= 0:
			$AnimatedSprite2D.play("Still")
		
		else:
			$AnimatedSprite2D.play("Move")
	
func _on_state_machine_took_dmg():
	$AnimatedSprite2D/damage.play("damage")

func free():
	queue_free()
