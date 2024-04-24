extends CharacterBody2D
class_name npc

@export var fsm : FiniteStateMachine

var player_can_chat = false
var player 




func start_interact():
	fsm._change_state($"StateMachine/Interacting")
	#Sprite turn towards player

func end_interact():
	fsm._change_state($"StateMachine/Idle")
	
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		start_interact()
		
func _physics_process(delta):
	move_and_slide()
	
	if velocity.length() > 0:
		$AnimatedSprite2D.play("Walk")
	
	else:
		$AnimatedSprite2D.play("Idle")





func _on_chat_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player_can_chat = true
	

func _on_chat_area_body_exited(body):
	if body.is_in_group("player"):
		player_can_chat = false
		end_interact()
		
