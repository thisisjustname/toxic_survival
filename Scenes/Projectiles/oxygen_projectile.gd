extends RigidBody2D

var green: bool = false
var mouse_in: bool = false

var ball_velocity: Vector2
var acceleration = 10

signal was_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	ball_velocity =  Vector2(randi() % 500 + 200, randi() % 500 + 200)
	linear_velocity = ball_velocity
	pass # Replace with function body.
	if(green):
		$Sprite2D.texture = load("res://bacteria_blue.png")
	else:
		$Sprite2D.texture = load("res://bacreia_red.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if Input.is_action_pressed("click") and mouse_in and not green:
		$Sprite2D.texture = load("res://bacteria_blue.png")
		green = true
		was_pressed.emit()

func _on_area_2d_mouse_entered():
	mouse_in = true


func _on_area_2d_mouse_exited():
	mouse_in = false
	
