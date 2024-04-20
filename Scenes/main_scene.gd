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
	pass # Replace with function body.

func update_stat_text():
	oxygen_label.text = "Oxygen: " + str(Globals.oxygen_count)
	mood_label.text = "Mood: " + str(Globals.mood_count)
	electricity_label.text = "Electricity: " + str(Globals.electricity_count)
	water_label.text = "Water: " + str(Globals.water_count)

func _process(delta):
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
	if index == 0:
		start_oxygen_game.emit()
	elif index == 1:
		print("mood mini game")
	elif index == 2:
		print("elec mini game")
	else:
		start_water_game.emit()
		


func _on_oxygen_game_player_lose():
	$GameResult.text = "Player lose haha!!!"
	$GameResult.show()
	await get_tree().create_timer(1).timeout
	$GameResult.hide()
	$StatsContainer.show()
	Globals.oxygen_count -= 1000
	print("lose")
	var set_not_active = $Buttons.get_children()
	for item in set_not_active:
		item.mouse_filter = MOUSE_FILTER_STOP
	$ButtonMenu.show()
	pass # Replace with function body.


func _on_oxygen_game_player_won():
	$StatsContainer.show()
	$GameResult.text = "Player won!!!"
	$GameResult.show()
	await get_tree().create_timer(1).timeout
	$GameResult.hide()
	Globals.oxygen_count += 1000
	var set_not_active = $Buttons.get_children()
	$ButtonMenu.show()
	for item in set_not_active:
		item.mouse_filter = MOUSE_FILTER_STOP
	pass # Replace with function body.


func _on_pipe_game_player_lose():
	$GameResult.text = "Player lose haha!!!"
	$GameResult.show()
	await get_tree().create_timer(1).timeout
	$GameResult.hide()
	$StatsContainer.show()
	Globals.water_count -= 1000
	print("lose")
	var set_not_active = $Buttons.get_children()
	for item in set_not_active:
		item.mouse_filter = MOUSE_FILTER_STOP
	$ButtonMenu.show()


func _on_pipe_game_player_won():
	$StatsContainer.show()
	$GameResult.text = "Player won!!!"
	$GameResult.show()
	await get_tree().create_timer(1).timeout
	$GameResult.hide()
	Globals.water_count += 1000
	var set_not_active = $Buttons.get_children()
	$ButtonMenu.show()
	for item in set_not_active:
		item.mouse_filter = MOUSE_FILTER_STOP
