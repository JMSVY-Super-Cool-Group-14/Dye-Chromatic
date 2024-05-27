extends TextureRect

@onready var boss_sm = $"../../Fire Boss/StateMachine"

func _ready():
	print(boss_sm)
	boss_sm.phase3_start.connect(hide_hammer)

func hide_hammer():
	self.visible = false
