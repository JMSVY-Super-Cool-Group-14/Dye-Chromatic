extends State
class_name enemyChase


@export var move_speed := 40.0


@onready var enemy = $"../.."
@onready var player = $"../../../../Player"
@onready var sm = $".."
@onready var alert = $"../../Alerted"
@onready var confused = $"../../Confused"


func _enter_state():
	confused.visible = false
	alert.visible = true
	alert.play("default")

func _exit_state():
	alert.visible = false
	confused.visible = true
	confused.play("default")
	get_tree().create_timer(2).timeout.connect(func(): confused.visible = false)
	
func _state_physics_update(delta : float):
	if player != null:
		var direction = player.global_position - enemy.global_position

		enemy.velocity = direction.normalized() * move_speed
		
		if sm.health <= 0:
			sm._change_state($"../Death")
			
		if direction.length() > sm.chase_range:
			sm._change_state($"../Idle")
		
		if direction.length() <= sm.attack_range:
			sm._change_state($"../Attack")
		

