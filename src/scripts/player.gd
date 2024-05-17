extends Area2D

signal hp_change(hp)
signal colour_change(leftColour, rightColour, currentColour)
signal stamina_change(stamina)

var attackCooldown = 0.3
var colourSwitchDelay = 0.1
@export var maxHP = 100
@export var hp = 10
@export var hpRegen = 2
@export var hpRegenDelay = 10
@export var maxStamina = 100
@onready var stamina = maxStamina
@export var staminaRegen = 0.1
var combo1 = false
var combo2 = false
var isSprinting = false
var lockedOn = false
var targetLock = Vector2.ZERO
var timePassed = 0
var attackDelta = 0
var comboDelta = 0
var comboDamage = false
var colourSwitchDelta = 0

var meleeCost = 10
var rangedCost = 10
var blueSpecialCost = 40
var blueUltCost = 70
var magentaSpecialCost = 40
var abilityCooldown = 0.5
var magentaDelta = 0 	# set to 0 so it is not on cooldown at start
var blueDelta = 0 	# set to 0 so it is not on cooldown at start
var blueUltDelta = 0
@export var blueUltDamage = 70
@export var meleeRange = 18
var velocity = Vector2.ZERO
var leftColourSelect = ["grey", "red", "green", "blue"]
var rightColourSelect = ["grey", "red", "green", "blue"]
var colourWheel = {
	"grey" : Color(0.5, 0.5, 0.5),
	"red" : Color(1, 0, 0),
	"green" : Color(0, 1, 0),
	"blue" : Color(0, 0, 1),
	"yellow" : Color(1, 1, 0),
	"magenta" : Color(1, 0, 1), 
	"cyan" : Color(0, 1, 1)
}
@onready var leftIndex = 0
@onready var rightIndex = 0
@onready var leftColour = "grey"
@onready var rightColour = "grey"
@onready var currentColour = "grey"
@onready var rangedTarget = Vector2.ZERO
@export var field_of_view := 45.0
@onready var facingDirection = Vector2(0, 1)
@export var speed = 100
@export var sprintSpeed = 160
@onready var meleeNode = $"MeleeRange"
@onready var meleeAnimate1 = $"MeleeRange/MeleeAnimate1/MeleePlayer1"
@onready var meleeAnimate2 = $"MeleeRange/MeleeAnimate2/MeleePlayer2"
@onready var meleeHitbox = $"MeleeRange/MeleeHitbox"
@onready var targetLockArt = $"TargetLock"
var meleeDamage = 50
@onready var fsm = $"../FiniteStateMachine"
@onready var blueUlt = $"BlueUlt/CollisionShape2D"
var melee_scene = preload("res://scenes/attacks/meleeAttack.tscn")
var projectile_scene = preload("res://scenes/attacks/projectile.tscn")
var special_magenta_scene = preload("res://scenes/attacks/special_magenta.tscn")
var special_blue_scene = preload("res://scenes/attacks/special_blue.tscn")

# Boundary limits
@export var min_x = 50
@export var max_x = 950
@export var min_y = 50
@export var max_y = 550

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.play()
	attackDelta += delta
	timePassed += delta
	magentaDelta -= delta
	blueDelta -= delta
	blueUltDelta -= delta
	colourSwitchDelta += delta
	comboDelta += delta
	
	if stamina < maxStamina:
		stamina += staminaRegen
	stamina_change.emit(int(stamina))
	if timePassed > hpRegenDelay and hp < maxHP:
		print("Regenerate health! Health is: ", hp)
		hp += hpRegen
		timePassed = 0
		hp_change.emit(hp)
	
	# Colour Reset
	if Input.is_action_just_pressed("left_colour"):
		colour_reset()
	elif Input.is_action_just_pressed("right_colour"):
		colour_reset()
	
	if Input.is_action_pressed("sprint"):
		speed = sprintSpeed
		isSprinting = true
	elif Input.is_action_just_released("sprint"):
		speed = 100
		isSprinting = false
	
	# Movement

	if fsm.get_controller():
		velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		rangedTarget = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	else:
		key_move()
	
	# Facing direction check
	if velocity.length() > 0 and !lockedOn:
		facingDirection = velocity
	elif lockedOn and targetLock != null:
		facingDirection = (targetLock.global_transform.origin - self.global_transform.origin).normalized()
		targetLockArt.global_position = targetLock.global_position
	elif targetLock == null:
		# In event of locked enemy being dead
		print("Target dead! Reset Lock-on.")
		targetLock = 0
		targetLockArt.visible = false
		lockedOn = false
	
	# Actual moving of object

	if velocity.length() > 0:
		facingDirection = velocity

	position += velocity * delta * speed
	# Clamp the position within defined boundaries
	position.x = clamp(position.x, min_x, max_x)
	position.y = clamp(position.y, min_y, max_y)
	
func start(pos):
	position = pos
	show()

func key_move():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
func _input(event):
	if !isSprinting:
		# Handle colour input
		colour_input(event)
	
		# Handle attack input
		attack_input(event)
		
		#Handle lock on target input
		lock_on(event)
		
			
func lock_on(event):
	if event.is_action_pressed("lock_on") and lockedOn==false:
		targetLock = get_nearest_enemy()
		if targetLock != null:
			$DetectRange.global_position = self.global_position + facingDirection.normalized()*meleeRange
			$DetectRange.global_rotation = facingDirection.angle()
			lockedOn = true
			targetLockArt.visible = true
			print("locked on to: ")
			print(targetLock)
	elif event.is_action_pressed("lock_on"):
		lockedOn = false
		targetLockArt.visible = false
		print("Reset Lock-on")
	
func attack_input(event):
	if attackDelta > attackCooldown:
		if fsm.get_controller():
			if event.is_action_pressed("ranged_attack") and rangedTarget!=Vector2.ZERO:
				fire_projectile(rangedTarget, currentColour)
				attackDelta = 0
			elif event.is_action("melee_attack"):
				melee_attack()
				attackDelta = 0
			elif event.is_action_pressed("special_attack"):
				colour_special()
			elif event.is_action_pressed("ultimate_attack"):
				colour_ultimate()

		else:
			if event.is_action_pressed("ranged_attack"):
				var mouse_pos = get_global_mouse_position()
				fire_projectile(mouse_pos, currentColour)
				attackDelta = 0
			elif event.is_action_pressed("melee_attack"):
				melee_attack()
				attackDelta = 0
			elif event.is_action_pressed("special_attack"):
				colour_special()
			elif event.is_action_pressed("ultimate_attack"):
				colour_ultimate()
	
func fire_projectile(target_pos: Vector2, colour: String):
	if stamina > rangedCost:
		stamina -= rangedCost
		var projectile = projectile_scene.instantiate()
		add_child(projectile)
		projectile.set_colour(colourWheel[colour])
		projectile.global_position = global_position
		slow(0.7, 0.1)
		if fsm.get_controller():
			projectile.set_direction(target_pos)
		else:
			var direction = (target_pos - global_position).normalized()
			projectile.set_direction(direction)
	
func melee_attack_old():
	var melee_strike = melee_scene.instantiate()
	add_child(melee_strike)
	slow(0.9, 0.2)
	melee_strike.set_angle(facingDirection)
	melee_strike.set_colour(colourWheel[currentColour])
	melee_strike.global_position = global_position + facingDirection.normalized()*meleeRange
	
func melee_attack():
	if stamina > meleeCost:
		stamina -= meleeCost
		meleeNode.global_position = global_position + facingDirection.normalized()*meleeRange
		meleeNode.global_rotation = facingDirection.angle() + PI/2
		slow(0.95, 0.2)
		
		if combo1 == true and comboDelta < attackCooldown*5:
			meleeAnimate2.play("attack2")
			combo1 = false
			combo2 = true
			comboDelta = 0
		elif combo2 == true and comboDelta < attackCooldown*5:
			comboDamage = true
			meleeAnimate1.play("attack1")
			meleeAnimate2.play("attack2")
			combo2 = false
		else:
			meleeAnimate1.play("attack1")
			combo1 = true
			comboDelta = 0
	

func colour_reset():
	if !Input.is_action_pressed("left_colour") and !Input.is_action_pressed("right_colour"):
		return
	
	# Multiple wait checks for redundancy
	await get_tree().create_timer(0.2).timeout
	
	if !Input.is_action_pressed("left_colour") and !Input.is_action_pressed("right_colour"):
		return
	
	# Multiple wait checks for redundancy
	await get_tree().create_timer(0.2).timeout
	
	if !Input.is_action_pressed("left_colour") and !Input.is_action_pressed("right_colour"):
		return
	
	# Multiple wait checks for redundancy
	await get_tree().create_timer(0.2).timeout
	
	if !Input.is_action_pressed("left_colour") and !Input.is_action_pressed("right_colour"):
		return
	elif Input.is_action_pressed("left_colour") and Input.is_action_pressed("right_colour"):
		leftIndex = 0
		rightIndex = 0
		set_colour("grey", "grey")
	elif Input.is_action_pressed("left_colour"):
		leftIndex = 0
		set_colour("grey", rightColour)
	elif Input.is_action_pressed("right_colour"):
		rightIndex = 0
		set_colour(leftColour, "grey")


func colour_input(event):
	# Toggle colours selected

	if colourSwitchDelta > colourSwitchDelay:
		colourSwitchDelta = 0
		if event.is_action_pressed("left_colour") :
			# So we dont have same colour on both sides
			leftIndex = (leftIndex+1) % 4
			if leftIndex == rightIndex:	
				leftIndex = (leftIndex+1) % 4
				set_colour(leftColourSelect[leftIndex], rightColourSelect[rightIndex])
			else:
				set_colour(leftColourSelect[leftIndex], rightColourSelect[rightIndex])
		elif event.is_action_pressed("right_colour"):
			# So we dont have same colour on both sides
			rightIndex = (rightIndex+1) % 4
			if rightIndex == leftIndex:
				rightIndex = (rightIndex+1) % 4
				set_colour(leftColourSelect[leftIndex], rightColourSelect[rightIndex])
			else:
				set_colour(leftColourSelect[leftIndex], rightColourSelect[rightIndex])

func set_colour(left, right):
	leftColour = left
	rightColour = right
	if leftColour!="grey" and rightColour!="grey":
		match [leftColour, rightColour]:
			["red", "green"]:
				currentColour = "yellow"
			["red", "blue"]:
				currentColour = "magenta"
			["green", "blue"]:
				currentColour = "cyan"
			["green", "red"]:
				currentColour = "yellow"
			["blue", "red"]:
				currentColour = "magenta"
			["blue", "green"]:
				currentColour = "cyan"
	elif left=="grey":
		currentColour = rightColour
	elif right == "grey":
		currentColour = leftColour
	
	colour_change.emit(leftColour, rightColour, currentColour)


func colour_special():
	match currentColour:
		"grey":
			print("greySpecial")
		"red":
			print("redSpecial")
		"green":
			print("greenSpecial")
		"blue":
			print("blueSpecial")
			if blueDelta <= 0 and stamina > blueSpecialCost:
				stamina -= blueSpecialCost
				blueDelta = abilityCooldown
				var blue_special = special_blue_scene.instantiate()
				add_child(blue_special)
				blue_special.global_position = global_position
				slow(0.7, 0.1)
				if fsm.get_controller():
					blue_special.set_direction(rangedTarget)
				else:
					var mouse_pos = get_global_mouse_position()
					var direction = (mouse_pos - global_position).normalized()
					blue_special.set_direction(direction)
		"yellow":
			print("yellowSpecial")
		"magenta":
			if magentaDelta <= 0 and stamina > magentaSpecialCost:
				stamina -= magentaSpecialCost
				magentaDelta = abilityCooldown
				var magenta_special = special_magenta_scene.instantiate()
				add_child(magenta_special)
				magenta_special.teleport(facingDirection)
				slow(0.5, 0.5)
		"cyan":
			print("cyanSpecial")

func colour_ultimate():
	match currentColour:
		"grey":
			print("greyUlt")
		"red":
			print("redUlt")
		"green":
			print("greenUltt")
		"blue":
			print("blueUlt")
			if blueUltDelta <= 0 and stamina > blueUltCost:
				blueUltDelta = abilityCooldown
				stamina -= blueUltCost
				slow(0.8, 0.5)
				blueUlt.set_disabled(false)
				await get_tree().create_timer(0.1).timeout
				blueUlt.set_disabled(true)
		"yellow":
			print("yellowUlt")
		"magenta":
			print("magentaUlt")
		"cyan":
			print("cyanUlt")

func slow(slow_amount: float, slow_duration: float):
	var original_speed = speed
	speed = speed * abs(1 - slow_amount)
	await get_tree().create_timer(slow_duration).timeout
	speed = original_speed

func take_fixed_damage(damage: int):
	hp -= damage
	print(hp)
	hp_change.emit(hp)

func take_DOT_damage(damage: float, duration: float):
	var tick = damage / duration
	for n in range(0, damage, tick):
		hp -= tick
		hp_change.emit(hp)
		
func _on_blue_ult_body_entered(body):
	if body.is_in_group("enemy"):
		body.fsm.take_DOT_damage(blueUltDamage, 7)
		var attack_type = "blueUlt"
		body.recieve_knockeback(self.global_position, 0, attack_type)

func _on_melee_range_body_entered(body):
	if body.is_in_group("enemy"):
		if comboDamage:
			body.fsm.take_damage(meleeDamage*2)
			body.recieve_knockeback(self.global_position, meleeDamage, "melee")
			comboDamage = false
		else:
			body.fsm.take_damage(meleeDamage)
			body.recieve_knockeback(self.global_position, meleeDamage, "melee")

func get_nearest_enemy() -> enemy:
	var nearest_enemy = null
	var front_enemies := []
	
	for target in $DetectRange.get_overlapping_bodies():
		#get enemies in front of the player
		#to find out, look for angle to enemy using dot product
		var angle_to_node = rad_to_deg(acos(facingDirection.dot(global_position.direction_to(target.global_position))))
		if angle_to_node < field_of_view and target.is_in_group("enemy"):
			front_enemies.append(target)
	
	if !front_enemies.is_empty():
		nearest_enemy = front_enemies[0]
		
		for target in front_enemies:
			#get enemies based on the closest distance
			if global_position.distance_to(target.global_position) < global_position.distance_to(nearest_enemy.global_position):
				nearest_enemy = target

	return nearest_enemy
