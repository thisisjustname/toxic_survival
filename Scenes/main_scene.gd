extends Control

@onready var oxygen_label: Label = $StatsContainer/Oxygen
@onready var mood_label: Label = $StatsContainer/Mood
@onready var electricity_label: Label = $StatsContainer/Electricity
@onready var water_label: Label = $StatsContainer/Water
signal change_text(index)
signal start_oxygen_game
signal start_water_game


# Called when the node enters the scene tree for the first time.
func _ready():
	$GameResult.hide()
	Globals.connect("stat_change", update_stat_text)
	update_stat_text()
	$Timers/EventsTimer.start()

func update_stat_text():
	oxygen_label.text = "Oxygen: " + str(Globals.oxygen_count)
	mood_label.text = "Mood: " + str(Globals.mood_count)
	electricity_label.text = "Electricity: " + str(Globals.electricity_count)
	water_label.text = "Water: " + str(Globals.water_count)

func _process(_delta):
	pass


func _on_oxygen_button_pressed():
	change_text.emit(0)
	
func _on_mood_button_pressed():
	change_text.emit(1)


func _on_electricity_electricity_pressed():
	change_text.emit(2)


func _on_water_button_pressed():
	change_text.emit(3)


func _on_button_menu_start_minigame(index):
	var set_not_active = $Buttons.get_children()
	$StatsContainer.hide()
	$ButtonMenu.hide()
	for item in set_not_active:
		item.mouse_filter = MOUSE_FILTER_IGNORE
	match index:
		0:
			start_oxygen_game.emit()
		1:
			print("mood mini game")
		2:
			print("elec mini game")
		3:
			start_water_game.emit()


func _on_oxygen_game_player_lose():
	Globals.oxygen_count -= 1000
	end_game_screen("Phayer lose, haha")


func _on_oxygen_game_player_won():
	Globals.oxygen_count += 1000
	end_game_screen("Phayer won !!!")

func _on_pipe_game_player_lose():
	Globals.water_count -= 1000
	end_game_screen("Phayer lose, haha")


func _on_pipe_game_player_won():
	Globals.water_count += 1000
	end_game_screen("Phayer won !!!")
		
func end_game_screen(str: String):
	$GameResult.text = str
	$GameResult.show()
	await get_tree().create_timer(1).timeout
	$GameResult.hide()
	$StatsContainer.show()
	var set_active = $Buttons.get_children()
	for item in set_active:
		item.mouse_filter = MOUSE_FILTER_STOP
	$ButtonMenu.show()


func _on_events_timer_timeout():
	$ButtonMenu.visible = false


func _on_event_event_end(resourse_type, amount, duration):
	print(resourse_type)
	print(amount)
	print(duration)
	$ButtonMenu.visible = true
