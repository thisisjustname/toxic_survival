extends Node

signal event_end(resourse_type: int, amount: int, duration: int)
var button_preset = preload("res://Scenes/texture_button.tscn")

var item_data = {}

var data_file_path = "res://Assets/Events/events.json"


var events = []
var event_indices: Array = []
var current_event_index: int = 0
var max_label_height: int

var current_event: Dictionary
var answer: String
@onready var label: Label = $TextureRect/Ask/EventText
@onready var first_variant: Label = $TextureRect/Ask/FirstVariant/Label
@onready var second_variant: Label = $TextureRect/Ask/SecondVariant/Label
@onready var result_label: Label = $TextureRect/Answer/AnswerText


func _ready():
	max_label_height = $TextureRect/Ask.size.y
	load_events(data_file_path)
	reset_events()
	
func add_button(event):
	var button = button_preset.instantiate() as TextureButton
	var index: int = $TextureRect/Ask.get_children().size() - 1
	button.get_children()[0].text = event["options"][str(index)]["text"]
	button.get_children()[0].add_theme_font_size_override("font_size", 20)
	$TextureRect/Ask.add_child(button)
	button.connect("pressed", Callable(self, "on_button_press").bind(index))

func on_button_press(index: int):
	handle_choice(str(index))

func load_events(file_path: String):
	var file = FileAccess.open(data_file_path, FileAccess.READ)
	if file:
		var json = file.get_as_text()
		var data = JSON.parse_string(json)
		if data is Dictionary:
			events = data["events"]
		else:
			print("Failed to parse JSON: ", data.error_string)
		file.close()
	else:
		print("events.json not found")
		
func shuffle(arr: Array):
	var n = arr.size()
	for i in range(n):
		var j = randi() % n
		var temp = arr[i]
		arr[i] = arr[j]
		arr[j] = temp
		
func reset_events():
	var n = events.size()
	event_indices = []
	for i in range(n):
		event_indices.append(i)
	shuffle(event_indices)
	current_event_index = 0
	
	
	
func handle_choice(option: String):
	answer = option
	var result = current_event["options"][option]["result"]
	print(result)
	result_label.text = result
	$TextureRect/Ask.visible = false
	$TextureRect/Answer.visible = true
	
func show_event(event: Dictionary):
	current_event = event
	#label.text = event["description"]
	print("options size")
	print(event["options"].size())
	for i in event["options"].size():
		add_button(event)
	#first_variant.text = event["options"]["a"]["text"]
	#second_variant.text = event["options"]["b"]["text"]
	$TextureRect/Answer.visible = false
	self.visible = true
	print("size " + str(label.get_minimum_size().y))


func _on_events_timer_timeout():
	if current_event_index < event_indices.size():
		var event = events[event_indices[current_event_index]]
		show_event(event)
		current_event_index += 1
	else:
		print("All events have been shown")


func _on_ok_pressed():
	self.visible = false
	var emit_resourse_type = current_event["options"][answer]["resourse_type"]
	var emit_amount: int = current_event["options"][answer]["amount"]
	var emit_duration: int = current_event["options"][answer]["duration"]
	event_end.emit(emit_resourse_type, emit_amount, emit_duration)
