extends Area2D

var original_speed = 100
var melee_slowdown = 10
var lifespan = 0.10
var existenceTime = 0
var damage = 50
var attack_type = "melee"
@onready var fsm = $"../../FiniteStateMachine"
#@onready var player = $"../Player"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	existenceTime += delta
	if existenceTime > lifespan:
		queue_free()

func set_angle(direction: Vector2):
		self.global_rotation = direction.angle()

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		if fsm.get_controller():
			Input.start_joy_vibration(0, 1, 1, 0.15)
		print("enemy hit melee!")
		# insert call to enemy.takedamage function
		body.fsm.take_damage(damage, attack_type)
		print(body.is_in_group("boss"))
		if !body.is_in_group("boss"):
			body.recieve_knockeback(self.global_position, damage, attack_type)

func set_colour(colour: Color):
	$Sprite2D.self_modulate = colour
