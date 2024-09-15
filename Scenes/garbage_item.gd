extends CharacterBody2D

var speed = 100  # Скорость движения объекта
var dragging = false
var original_position = Vector2.ZERO
var target_position = Vector2.ZERO
var elapsed_time = 0
var shader_material: ShaderMaterial
var rng = RandomNumberGenerator.new()
var type: int = rng.randi_range(0, 2)
var in_drop_area: bool = false
signal object_delivered

@export var type1_file_dir : String = "res://Assets/GarbageItems/Type1/"
@export var type2_file_dir : String = "res://Assets/GarbageItems/Type2/"
@export var type3_file_dir : String = "res://Assets/GarbageItems/Type3/"

var file_names_type1 = []
var file_names_type2 = []
var file_names_type3 = []

func load_random_image(directory: String):
	var dir = DirAccess.open(directory)
	if dir:
		var file_names = []
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".png"):
				file_names.append(file_name)
			file_name = dir.get_next()
		return file_names
			
func set_texture(file_names, path):
	if file_names.size() > 0:
			var random_image = file_names[randi() % file_names.size()]
			print(path + random_image)
			$Sprite2D.texture = load(path + random_image)

func _ready():
	shader_material = $Sprite2D.material as ShaderMaterial
	file_names_type1 = load_random_image(type1_file_dir)
	file_names_type2 = load_random_image(type2_file_dir)
	file_names_type3 = load_random_image(type3_file_dir)
	
	shader_material.set_shader_parameter("lightning_intensity", 0.0)  # Выключаем эффект изначально
	if type == 0:
		set_texture(file_names_type1, type1_file_dir)
	elif type == 1:
		set_texture(file_names_type2, type2_file_dir)
	else :
		set_texture(file_names_type3, type3_file_dir)
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
				shader_material.set_shader_parameter("lightning_intensity", 1)
				get_viewport().set_input_as_handled()
			else:
				shader_material.set_shader_parameter("lightning_intensity", 0.0)
				dragging = false
				if in_drop_area:
					object_delivered.emit()
					print("Объект успешно доставлен")
					queue_free()
				get_viewport().set_input_as_handled()

func _input(event):
	if dragging and event is InputEventMouseMotion:
		position = get_global_mouse_position()
		get_viewport().set_input_as_handled()
