extends Control

signal player_won
signal player_lose

var pipe_button = preload("res://Scenes/pipe_button.tscn")

var first_move_index: int = 0
var first_shuffle_index: int = 0
var second_move_index: int = 0
var first_was_pressed: bool = false
var remember_array = []
var game_array = []
var remember_state: bool = false
var game_state: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	
func show_remember_buttons():
	remember_state = true
	$VBoxContainer.add_theme_constant_override("separation", -12)
	add_button(-1, -1)
	for i in 8:
		add_button(remember_array[i], i)
		add_button(0, -1)
	$RememberTimer.start()

func show_game_buttons():
	game_state = true
	$VBoxContainer.add_theme_constant_override("separation", -17)
	add_button(-1, -1)
	for i in 5:
		add_button(game_array[i], i)
		add_button(0, -1)
	$GameTimer.start()


func _process(_delta):
	if remember_state:
		$Label.text = "Remerber order: " + str(int($RememberTimer.get_time_left()))
	if game_state :
		$Label.text = "Time left: " + str(int($GameTimer.get_time_left()))


func _on_main_scene_start_water_game():
	self.show()
	print("start water game")
	for i in range(1, 9):
		remember_array.append(i)
	remember_array.shuffle()
	for i in range(1, 9):
		game_array.append(i)
	game_array.resize(game_array.size() - 3)
	show_remember_buttons()
		
func add_button(shuffle_index: int, index: int):
	var button = pipe_button.instantiate() as TextureButton
	if remember_state:
		button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if shuffle_index == 0 or shuffle_index == -1:
			button.custom_minimum_size = Vector2(42, 42)
	else:
		button.custom_minimum_size = Vector2(100, 100)
		if shuffle_index == 0 or shuffle_index == -1:
			button.custom_minimum_size = Vector2(60, 60)
	match shuffle_index:
		-1:
			button.texture_normal = load("res://Assets/Pipe/water3.png")
		0:
			button.texture_normal = load("res://Assets/Pipe/water.png")
		1:
			button.texture_normal = load("res://Assets/Pipe/pipe1.png")
		2:
			button.texture_normal = load("res://Assets/Pipe/pipe2.png")
		3:
			button.texture_normal = load("res://Assets/Pipe/pipe3.png")
		4:
			button.texture_normal = load("res://Assets/Pipe/pipe4.png")
		5:
			button.texture_normal = load("res://Assets/Pipe/pipe5.png")
		6:
			button.texture_normal = load("res://Assets/Pipe/pipe6.png")
		7:
			button.texture_normal = load("res://Assets/Pipe/pipe7.png")
		8:
			button.texture_normal = load("res://Assets/Pipe/pipe8.png")
	if shuffle_index != 0:
		button.connect("pressed", Callable(self, "get_button_indexes").bind(shuffle_index, index))
	$VBoxContainer.add_child(button)

	
func get_button_indexes(shuffle_index: int, index: int):
	if not first_was_pressed:
		first_shuffle_index = shuffle_index
		first_move_index = index
		first_was_pressed = true
	else:
		if index == first_move_index - 1 or index == first_move_index + 1:
			$VBoxContainer.get_child(index + 1).disconnect("pressed", Callable(self, "get_button_indexes"))
			$VBoxContainer.get_child(index + 1).connect("pressed", Callable(self, "get_button_indexes").bind(shuffle_index, first_move_index))
			$VBoxContainer.get_child(index + 1).index = first_move_index
			$VBoxContainer.get_child(index + 1).shuffle_index = shuffle_index
			$VBoxContainer.get_child(first_move_index + 1).disconnect("pressed", Callable(self, "get_button_indexes"))
			$VBoxContainer.get_child(first_move_index + 1).connect("pressed", Callable(self, "get_button_indexes").bind(first_shuffle_index, index))
			$VBoxContainer.get_child(first_move_index + 1).index = index
			$VBoxContainer.get_child(first_move_index + 1).shuffle_index = first_shuffle_index
			$VBoxContainer.move_child($VBoxContainer.get_child(first_move_index + 1), index + 1)
			first_was_pressed = false
			check_player_won()


func check_player_won():
	var check_array = []
	for i in range(1, $VBoxContainer.get_children().size() - 1):
		check_array.append($VBoxContainer.get_child(i).shuffle_index)
	var temp_array = []
	for element in remember_array:
		if element in check_array:
			temp_array.append(element)
	if temp_array == check_array:
		player_won.emit()
		$GameTimer.stop()
		clear_all()
		
func _on_remember_timer_timeout():
	remember_state = false
	print("time out")
	for i in range(0, $VBoxContainer.get_children().size()):
		$VBoxContainer.get_child(i).queue_free()
	show_game_buttons()


func _on_game_timer_timeout():
	clear_all()
	player_lose.emit()

func clear_all():
	self.hide()
	first_was_pressed = false
	game_state = false
	remember_state = false
	remember_array.clear()
	game_array.clear()
	for i in range(0, $VBoxContainer.get_children().size()):
		$VBoxContainer.get_child(i).queue_free()
