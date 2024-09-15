extends Node2D

var oxygen_pojectile_scene = preload("res://Scenes/garbage_item.tscn")
var rng = RandomNumberGenerator.new()
var positions
var score: int = 0
var game_was_started: bool = false
signal electricity_game_end(score: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	positions = $SpawnPoints.get_children()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_was_started:
		$TimerText.text = "Time left: " + str(int($GameTimer.get_time_left()))
	
func summon_particle(pos: Vector2):
	var pojectile = oxygen_pojectile_scene.instantiate() as CharacterBody2D
	pojectile.position = pos
	pojectile.connect("object_delivered", Callable(self, "_on_object_delivered"))
	$Grarbage.add_child(pojectile)
	
func update_score_text():
	$Score.text = "Score: " + str(score)

func _on_object_delivered():
	score += 10
	update_score_text()

func _on_garbage_summon_timeout() -> void:
	var my_random_number = rng.randi_range(0, positions.size())
	print(positions[my_random_number - 1].global_position)
	summon_particle(positions[my_random_number - 1].global_position)
	pass # Replace with function body.
	

func _on_delete_area_body_entered(body: Node2D) -> void:
	score -= 20
	body.queue_free()
	update_score_text()


func _on_test_signal_test(str: String) -> void:
	print(str)


func _on_area_2d_body(body: Node2D, type: int, in_drop_area: bool) -> void:
	if type == body.type:
		body.in_drop_area = in_drop_area


func _on_main_scene_start_electricity_game() -> void:
	game_was_started = true
	$GameTimer.start()
	$GarbageSummon.start()
	self.show()
	var window_size = get_tree().root.size
	var content_scale_factor = get_tree().root.content_scale_factor


func _on_game_timer_timeout() -> void:
	electricity_game_end.emit(score)
	clear_all()
	
func clear_all():
	game_was_started = false
	$GarbageSummon.stop()
	self.hide()
	clear()
	
func clear():
	var children = $Grarbage.get_children()
	for child in children:
		child.queue_free()
