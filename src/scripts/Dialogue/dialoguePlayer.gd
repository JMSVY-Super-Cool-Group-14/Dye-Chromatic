extends Control

@export_file("*.json") var d_file

signal dialogue_done

var dialogue = []
var current_line = 0

func _ready():
	self.visible = false
	dialogue = load_dialogue()

func load_dialogue():
	var file = FileAccess.open("res://scripts/Dialogue/redSlimeDialogue.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func next_line():
	if current_line < len(dialogue):
		print("here")
		self.visible = true
		$name.text = dialogue[current_line]["name"]
		$text.text = dialogue[current_line]["text"]
		current_line += 1
	else:
		end_dialogue()

func end_dialogue():
	self.visible = false
	current_line = 0
	dialogue_done.emit()

	


