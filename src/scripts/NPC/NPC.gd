extends CharacterBody2D
class_name npc

@onready var sm = $"StateMachine"
@onready var dialogue_box = $"DialogueBox"
@onready var player = $"../../../Player"


var player_can_chat = false
var interacting = false


func start_interact():
	sm._change_state($"StateMachine/Interacting")
	#Sprite turn towards player

func end_interact():
	sm._change_state($"StateMachine/Idle")
	
func _process(delta):
	if Input.is_action_just_pressed("interact") and player_can_chat:
		sm._change_state($"StateMachine/Interacting")
		interacting = true
		dialogue_box.next_line()
		
func _physics_process(delta):
	move_and_slide()
	player_distance()
	if velocity.length() > 0:
		$AnimatedSprite2D.play("Walk")
	
	else:
		$AnimatedSprite2D.play("Idle")

func player_distance():
	var direction = player.global_position - self.global_position
	if direction.length() <= 50:
		player_can_chat = true
	else: 
		player_can_chat = false
		end_interaction()
	
func _on_dialogue_box_dialogue_done():
	end_interact()

func end_interaction():
	if interacting:
		dialogue_box.end_dialogue()
	
