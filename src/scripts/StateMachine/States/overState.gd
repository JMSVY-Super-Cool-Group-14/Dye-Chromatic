extends State

@onready var player = $"/root/Game/Areas/Global/Player"
@onready var UI = $"../..//UI"

const end_screen = preload("res://scenes/ui/death_screen.tscn")
var game_over

func _enter_state():
	game_over = end_screen.instantiate()
	add_child(game_over)
	UI.visible = false
	game_over.restart.connect(_restart)
	game_over.exit.connect(_save)
	get_tree().paused = true

func _restart():
	remove_child(game_over)
	state_machine._change_state($"../InGame")
	player.position = state_machine.check_point_pos
	player.hp = player.maxHP
	player.stamina = player.maxStamina
	player.hp_change.emit(player.hp)
	UI.visible = true
	
func _save():
	state_machine._save()
