extends Node2D

var oxygen_pojectile_scene = preload("res://Scenes/garbage_item.tscn")
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func summon_particle(pos: Vector2):
	var pojectile = oxygen_pojectile_scene.instantiate() as CharacterBody2D
	pojectile.position = pos
	$Grarbage.add_child(pojectile)


func _on_garbage_summon_timeout() -> void:
	var positions = $SpawnPoints.get_children()
	var my_random_number = rng.randi_range(0, positions.size())
	print(positions[my_random_number - 1].global_position)
	summon_particle(positions[my_random_number - 1].global_position)
	pass # Replace with function body.
	
func check_body(body: CharacterBody2D, type: int, in_drop_area: bool):
	if type == body.type:
		body.in_drop_area = in_drop_area


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	check_body(body, 0, true)


func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	check_body(body, 0, false)


func _on_area_2d_2_body_entered(body: CharacterBody2D) -> void:
	check_body(body, 1, true)


func _on_area_2d_2_body_exited(body: CharacterBody2D) -> void:
	check_body(body, 1, false)


func _on_area_2d_yellow_body_entered(body: Node2D) -> void:
	check_body(body, 2, true)


func _on_area_2d_yellow_body_exited(body: Node2D) -> void:
	check_body(body, 2, false)


func _on_delete_area_body_entered(body: Node2D) -> void:
	body.queue_free()
