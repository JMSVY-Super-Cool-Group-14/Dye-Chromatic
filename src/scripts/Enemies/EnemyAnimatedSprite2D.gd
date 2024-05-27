extends AnimatedSprite2D

@onready var charger = $".."
@onready var sm = $"../State Machine"
var charging_val = false
var last_move = "down"
var main_dir
var dir_value

@onready var shield = $"../Shield"
@onready var hit_box = $"../Hit Box"




func _ready():
	animation_looped.connect(end_attack)
	set_process(true)
	print(shield)
	print(hit_box)

func _process(delta):
	if !charging_val and int(delta) % 5 == 0 and !sm.current_state.name != "Death":
		var velocity = charger.velocity.normalized()
		# walk_idle(velocity)
		

	# Only debug information should be here, movement is removed
	#print("Player Position: ", player.position)
	#print("Viewport Size: ", get_viewport().size)

func end_attack():
	charging_val = false

func walk_idle(velocity):
	if charger.velocity.length() <= 0:
		if last_move == "down":
			self.play("Idle_Down")
		elif last_move == "up":
			self.play("Idle_Up")
		elif last_move == "right":
			self.play("Idle_Side")
			flip_h == true
		elif last_move == "left":
			self.play("Idle_Side")
			flip_h = false
		return
	
	# Walking animation

	
	if velocity.x > 0.25:
		self.play("Move_Side")
		flip_h = true
		last_move = "right"
	elif velocity.x < -0.25:
		self.play("Move_Side")
		flip_h = false
		last_move = "left"
	elif velocity.y > 0:
		self.play("Move_Down")
		last_move = "down"
	elif velocity.y < 0:
		self.play("Move_Up")
		last_move = "up"

	
