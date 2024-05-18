extends Node

var item_data = {}

var data_file_path = "res://Assets/Events/events.json"

var events = []

func _ready():
	load_events(data_file_path)

func load_events(file_path: String):
	if FileAccess.file_exists(file_path):
		var dataFile = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(dataFile.get_as_text())
