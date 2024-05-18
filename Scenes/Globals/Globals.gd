extends Node

signal stat_change

var resourse_was_pressed = [0, 0, 0, 0]



var oxygen_count: int = 100:
	set(value):
		oxygen_count = value
		stat_change.emit()
var mood_count: int = 100:
	set(value):
		mood_count = value
		stat_change.emit()
var electricity_count: int = 100:
	set(value):
		electricity_count = value
		stat_change.emit()
var water_count: int = 100:
	set(value):
		water_count = value
		stat_change.emit()
