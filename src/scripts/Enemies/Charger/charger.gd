extends enemy

@onready var shield = $Shield
@onready var hit_box = $"Hit Box"



func collision_boxes(dir, right=false):
	
	for child in shield.get_children():
		if child.name == dir:
			child.disabled = false
			if right:
				child.scale.x = -abs(child.scale.x)
			else:
				child.scale.x = abs(child.scale.x)
		else: 
			child.disabled = true
			if right:
				child.scale.x = -abs(child.scale.x)
			else:
				child.scale.x = abs(child.scale.x)
	
	
	for child in hit_box.get_children():
		if child.name == dir:
			child.disabled = false
		else: 
			child.disabled = true

func _physics_process(delta):
	move_and_slide()
	if fsm.health <= 0:
		self.velocity = Vector2.ZERO
		$AnimatedSprite2D.play("Death")
		if $AnimatedSprite2D.frame == 4:
			queue_free()
	if $AnimatedSprite2D.animation == "Idle_Down" or $AnimatedSprite2D.animation == "Move_Down":
		collision_boxes("front")
	elif $AnimatedSprite2D.animation == "Idle_Up" or $AnimatedSprite2D.animation == "Move_Up":
		collision_boxes("front")
	elif ($AnimatedSprite2D.animation == "Idle_Side" or $AnimatedSprite2D.animation == "Move_Side") and $AnimatedSprite2D.flip_h == false:
		collision_boxes("side")
	elif ($AnimatedSprite2D.animation == "Idle_Side" or $AnimatedSprite2D.animation == "Move_Side") and $AnimatedSprite2D.flip_h == true:
		collision_boxes("side", true)
		
		



