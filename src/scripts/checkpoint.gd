extends Area2D

@export var state_machine:FiniteStateMachine

func _on_area_entered(area):
	if state_machine.check_point != self && area.name == "Player":
		print("Checkpoint! ", area.position)
		state_machine.save_checkpoint(area.position, self)
		$CheckpointSound.play()
