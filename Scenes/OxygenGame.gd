extends Node2D

var oxygen_pojectile_scene = preload("res://Scenes/Projectiles/oxygen_projectile.tscn")
# Called when the node enters the scene tree for the first time.
var balls_count: int = 10
var red_count: int = 5
var was_pressed = 0
var game_was_started: bool = false

signal player_won
signal player_lose

func _ready():
	self.hide()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_was_started:
		$Control/TimeLeftLabel.text = "Time left: " + str(int($Timer.get_time_left()))
	
func increase_pressed():
	was_pressed += 1
	if(was_pressed == red_count):
		clear_all()
		player_won.emit()
		$Timer.stop()

func _on_timer_timeout():
	clear_all()
	player_lose.emit()
	
func clear_all():
	game_was_started = false
	self.hide()
	clear()
	was_pressed = 0
	
func clear():
	var children = $Projectiles.get_children()
	for child in children:
		child.queue_free()


func _on_main_scene_start_oxygen_game():
	game_was_started = true
	$Timer.start()
	self.show()
	var window_size = get_tree().root.size
	var content_scale_factor = get_tree().root.content_scale_factor
	var actual_scene_size = Vector2((window_size.x - 200) / content_scale_factor, (window_size.y - 200) / content_scale_factor)
	for i in range(red_count):
		var pojectile = oxygen_pojectile_scene.instantiate() as RigidBody2D
		pojectile.position = Vector2(randi() % int(actual_scene_size.x), randi() % int(actual_scene_size.y))
		pojectile.position = Vector2(270, 480)
		$Projectiles.add_child(pojectile)
	for i in range(balls_count - red_count):
		var pojectile = oxygen_pojectile_scene.instantiate() as RigidBody2D
		pojectile.position = Vector2(randi() % int(actual_scene_size.x), randi() % int(actual_scene_size.y))
		pojectile.position = Vector2(270, 480)
		pojectile.green = true
		$Projectiles.add_child(pojectile)
	for ball in $Projectiles.get_children():
		ball.connect("was_pressed", increase_pressed)	
	
