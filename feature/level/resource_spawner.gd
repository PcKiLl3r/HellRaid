extends Node2D

# Paths to the resource scenes
@export var iron_resource_scene: PackedScene
@export var stone_resource_scene: PackedScene
@export var wood_resource_scenes: Array[PackedScene]  # Array to hold multiple wood scenes

# Weights for rarity
@export var iron_weight: int = 1
@export var stone_weight: int = 1
@export var wood_weights: Array[int] = [1, 1]  # Weights for multiple wood scenes

# Grid settings
@export var grid_size: Vector2 = Vector2(100, 100)
@export var spawn_area_size: Vector2 = Vector2(1024, 1024)  # Define the spawn area size
@export var min_variation: Vector2 = Vector2(1, 1)  # Minimum variation in grid jumps
@export var max_variation: Vector2 = Vector2(3, 3)  # Maximum variation in grid jumps

func _ready():
	randomize()
	_randomly_spawn_resources()

func _randomly_spawn_resources():
	var grid_start = Vector2(-spawn_area_size.x / 2, -spawn_area_size.y / 2)
	var grid_end = Vector2(spawn_area_size.x / 2, spawn_area_size.y / 2)
	var current_position = grid_start

	while current_position.x <= grid_end.x:
		while current_position.y <= grid_end.y:
			var weighted_scenes = _get_weighted_scenes()
			var random_index = randi() % weighted_scenes.size()
			var selected_scene = weighted_scenes[random_index]

			_spawn_resource(selected_scene, current_position)

			# Jump to the next position within the variation range
			current_position.y += grid_size.y * randf_range(min_variation.y, max_variation.y)
		current_position.x += grid_size.x * randf_range(min_variation.x, max_variation.x)
		current_position.y = grid_start.y  # Reset y to start

func _get_weighted_scenes() -> Array[PackedScene]:
	var weighted_scenes: Array[PackedScene] = []
	for i in range(iron_weight):
		weighted_scenes.append(iron_resource_scene)
	for i in range(stone_weight):
		weighted_scenes.append(stone_resource_scene)
	for i in range(wood_resource_scenes.size()):
		for j in range(wood_weights[i]):
			weighted_scenes.append(wood_resource_scenes[i])
	return weighted_scenes

func _spawn_resource(resource_scene: PackedScene, position: Vector2):
	var instance = resource_scene.instantiate()
	add_child(instance)
	instance.position = position
