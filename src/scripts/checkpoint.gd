extends Area2D

@export var state_machine:FiniteStateMachine
var not_saved = preload("res://assets/Save-1.png")
var saved = preload("res://assets/Save-2.png")

func _on_area_entered(area):
	if state_machine.check_point != self && area.name == "Player":
		print("Checkpoint! ", area.position)
		state_machine.save_checkpoint(area.position, self)
		$CheckpointSound.play()
		$Sprite2D.texture = saved
		$GPUParticles2D.emitting = true
