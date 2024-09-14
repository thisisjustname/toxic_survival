extends CharacterBody2D

var speed = 100  # Скорость движения объекта
var dragging = false
var original_position = Vector2.ZERO
var target_position = Vector2.ZERO
var elapsed_time = 0
var rng = RandomNumberGenerator.new()
var type: int = rng.randi_range(0, 2)
var in_drop_area: bool = false

func _ready():
	if type == 0:
		$Sprite2D.texture = load("res://Scenes/Projectiles/temp_garbage_item.png")
	elif type == 1:
		$Sprite2D.texture = load("res://Scenes/temp_garbage_item2.png")
	else :
		$Sprite2D.texture = load("res://Scenes/temp_garbage_item3.png")
	original_position = position
	input_pickable = true  # Разрешаем объекту реагировать на ввод мыши

func _physics_process(delta):
	if not dragging:
		elapsed_time += delta
		target_position = original_position + Vector2(speed * elapsed_time, 0)
		velocity = (target_position - position) / delta
		move_and_slide()
		position = position.move_toward(target_position, speed * delta)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				get_viewport().set_input_as_handled()
			else:
				dragging = false
				if in_drop_area:
					print("Объект успешно доставлен")
					queue_free()
				get_viewport().set_input_as_handled()

func _input(event):
	if dragging and event is InputEventMouseMotion:
		position = get_global_mouse_position()
		get_viewport().set_input_as_handled()
