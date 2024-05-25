# enemyIdle.gd
extends State
class_name enemyIdle

@export var move_speed := 10.0

@onready var enemy = $"../.."
@onready var player = $"/root/Game/Areas/Global/Player"
@onready var sm = $".."

var move_dir : Vector2
var wander_time : float
var move_allowed = {
	"right": true,
	"left": true,
	"up": true,
	"down": true
}
var timers = {}

func _ready():
	# Assuming BoundariesBase is a sibling node in the scene tree
	var boundaries_base = get_node("/root/Game/Areas/BaseArea/NPCs/BaseZone/")
	if boundaries_base:
		boundaries_base.connect("boundary_hit", Callable(self, "_on_boundary_hit"))

	# Initialize the timers
	for direction in ["right", "left", "up", "down"]:
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = 5.0  # 5 seconds
		add_child(timer)
		timer.connect("timeout", Callable(self, "_on_timer_timeout").bind(direction))
		timers[direction] = timer

func random_wander():
	move_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)

func _enter_state():
	random_wander()

func _state_update(delta : float):
	if wander_time > 0:
		wander_time -= delta
	else:
		await get_tree().create_timer(2).timeout
		random_wander()

func _state_physics_update(delta : float):
	if enemy:
		var adjusted_move_dir = move_dir
		if move_dir.x > 0 and not move_allowed["right"]:
			adjusted_move_dir.x = 0
		if move_dir.x < 0 and not move_allowed["left"]:
			adjusted_move_dir.x = 0
		if move_dir.y > 0 and not move_allowed["down"]:
			adjusted_move_dir.y = 0
		if move_dir.y < 0 and not move_allowed["up"]:
			adjusted_move_dir.y = 0
		
		enemy.velocity = adjusted_move_dir * move_speed

	if player != null:
		var direction = player.global_position - enemy.global_position
		
		if sm.health <= 0:
			sm._change_state($"../Death")
		
		if direction.length() < sm.detection_range:
			sm._change_state($"../Chase")
		
		if direction.length() <= sm.attack_range - 10:
			if sm.melee:
				sm._change_state($"../Attack")
			else:
				sm._change_state($"../RangeAttack")

func _on_boundary_hit(character, boundary_direction):
	if character == enemy:
		if boundary_direction == Vector2(1, 0):
			move_allowed["right"] = false
			timers["right"].start()
		elif boundary_direction == Vector2(-1, 0):
			move_allowed["left"] = false
			timers["left"].start()
		elif boundary_direction == Vector2(0, 1):
			move_allowed["down"] = false
			timers["down"].start()
		elif boundary_direction == Vector2(0, -1):
			move_allowed["up"] = false
			timers["up"].start()

func _on_timer_timeout(direction):
	move_allowed[direction] = true
