extends State
class_name enemyStun

@onready var enemy = $"../.."
@onready var player = $"/root/Game/Player"
@onready var sm = $".."

var free = false
var stun_time = 2

signal attacking
		
func _enter_state():
	enemy.velocity = Vector2.ZERO
	free = false
	get_tree().create_timer(stun_time).timeout.connect(func(): free = true)
	
func _state_update(delta : float):
	if free:
		$".."._change_state($"../Chase")
