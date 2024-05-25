extends enemy

func _physics_process(delta):
	move_and_slide()
	if fsm.health <= 0:
		self.velocity = Vector2.ZERO
		$AnimatedSprite2D.play("Death")
		if $AnimatedSprite2D.frame == 4:
			queue_free()



