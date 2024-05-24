extends State

@onready var player = $"/root/Game/Areas/Global/Player"

const end_screen = preload("res://scenes/ui/death_screen.tscn")
var game_over

func _enter_state():
	game_over = end_screen.instantiate()
	add_child(game_over)
	game_over.restart.connect(_restart)
	game_over.exit.connect(_save)
	get_tree().paused = true

func _restart():
	remove_child(game_over)
	state_machine._change_state($"../InGame")
	player.position = state_machine.check_point_pos
	player.hp = player.maxHP
	player.hp_change.emit(player.hp)
	
func _save():
	state_machine._save()
