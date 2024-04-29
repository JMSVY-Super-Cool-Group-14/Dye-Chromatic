extends Control

@export_file("*.json") var d_file

signal dialogue_done

var dialogue = []
var current_dialogue_id = 0
var d_active = false

func _ready():
	self.visible = true
	
func start():
	if d_active:
		return
	d_active = true
	self.visible = true
	dialogue = load_dialogue()
	current_dialogue_id = -1
	next_script()

func load_dialogue():
	var file = FileAccess.open("res://scripts/Dialogue/redSlimeDialogue.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func _input(event):
	if !d_active:
		return
	if event.is_action_pressed("interact"):
		next_script()

func next_script():
	current_dialogue_id += 1
	if current_dialogue_id >= len(dialogue):
		d_active = false
		self.visible = false
		dialogue_done.emit()
		return
		
	$name.text = dialogue[current_dialogue_id]["name"]
	$text.text = dialogue[current_dialogue_id]["text"]
