extends Area2D

var lifespan = 0.10
var existenceTime = 0
var damage = 50
@onready var fsm = $"../../FiniteStateMachine"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	existenceTime += delta
	if existenceTime > lifespan:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		if fsm.get_controller():
			Input.start_joy_vibration(0, 1, 1, 0.15)
		print("enemy hit melee!")
		# insert call to enemy.takedamage function
		body.take_fixed_damage(damage)

func set_colour(colour: Color):
	$Sprite2D.self_modulate = colour