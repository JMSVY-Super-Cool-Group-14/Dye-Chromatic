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
	
	if state_machine.check_point == null:
		state_machine.set_player(Rect2(Vector2(0, 0), Vector2(1646*0.4, 1710*0.4)), Rect2(Vector2(10, 10), Vector2(1636*0.4, 1700*0.4)), state_machine.check_point_pos)
	else:
		state_machine.set_player(Rect2(Vector2(0, 800), Vector2(1817*0.5, 1469*0.5)), Rect2(Vector2(10, 810), Vector2(1807*0.5, 1459*0.5)), state_machine.check_point_pos)

	player.position = state_machine.check_point_pos
	player.hp = player.maxHP
	player.stamina = player.maxStamina
	player.hp_change.emit(player.hp)
	UI.visible = true
	
func _save():
	state_machine._save()
