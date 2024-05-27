extends State
class_name phase3

@onready var sm = $".."
@onready var boss = $"../.."
@onready var player = $"/root/Game/Areas/Global/Player"


var switch_timer = 2
var new_phase = false
var get_hammer = false
var hammer_timer = 20


func _choose_attack():
	if get_hammer:
		sm._change_state($"../Retrieve")
		sm.hammer_picked_up = true
		get_hammer = false
		
	elif sm.hammer_picked_up:
		sm.hammer_picked_up = false
		sm._change_state($"../Hammer")
		get_tree().create_timer(hammer_timer).timeout.connect(func(): get_hammer = true)
	
	elif (player.global_position - boss.global_position).length() <= sm.melee_range:
		sm._change_state($"../P3Melee")
	else:
		sm._change_state($"../P3orbAttack")
		
	

func _enter_state():
	#gå mot spelaren om tillräckligt nsära melee annars annan attack
	await get_tree().create_timer(switch_timer).timeout
	_choose_attack()

func _exit_state():
	boss.velocity = Vector2.ZERO

func _state_update(delta : float):
	pass
	
func _state_physics_update(delta : float):
	var direction = player.global_position - boss.global_position
	boss.velocity = direction.normalized() * sm.move_speed
	
	if sm.health <= 0:
		$"AnimatedSprite2D".play("Death")
		

