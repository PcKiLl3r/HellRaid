extends Node2D

enum ObjectType { NONE, WOOD_WALL, STONE_WALL, TRAP, TURRET }

const WOOD_WALL_COST = {"wood": 10, "stone": 0, "iron": 0}
const STONE_WALL_COST = {"wood": 0, "stone": 10, "iron": 0}
const TRAP_COST = {"wood": 0, "stone": 0, "iron": 0}
const TURRET_COST = {"wood": 0, "stone": 0, "iron": 0}

const PLACEMENT_DISTANCE = 50  # Razdalja od igralca, kjer bo objekt postavljen

var selected_object_type = ObjectType.NONE
var current_preview_instance = null

@export var WoodWallScene: PackedScene
@export var StoneWallScene: PackedScene
@export var TrapScene: PackedScene
@export var TurretScene: PackedScene

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().connect("wall_removed", Callable(self, "_on_wall_removed"))

func _process(delta):
	if Input.is_action_just_pressed("select_wood_wall"):
		select_object(ObjectType.WOOD_WALL)
	elif Input.is_action_just_pressed("select_stone_wall"):
		select_object(ObjectType.STONE_WALL)
	elif Input.is_action_just_pressed("select_trap"):
		select_object(ObjectType.TRAP)
	elif Input.is_action_just_pressed("select_turret"):
		select_object(ObjectType.TURRET)
	elif Input.is_action_just_pressed("cancel_selection"):
		deselect_object()

	if selected_object_type != ObjectType.NONE:
		update_preview_position()
		if Input.is_action_just_pressed("place_object"):
			place_object()

func select_object(object_type):
	selected_object_type = object_type
	if current_preview_instance:
		current_preview_instance.queue_free()
	match selected_object_type:
		ObjectType.WOOD_WALL:
			current_preview_instance = WoodWallScene.instantiate()
		ObjectType.STONE_WALL:
			current_preview_instance = StoneWallScene.instantiate()
		ObjectType.TRAP:
			current_preview_instance = TrapScene.instantiate()
		ObjectType.TURRET:
			current_preview_instance = TurretScene.instantiate()
	add_child(current_preview_instance)

func deselect_object():
	selected_object_type = ObjectType.NONE
	if current_preview_instance:
		current_preview_instance.queue_free()
		current_preview_instance = null

func update_preview_position():
	if not player:
		return
	
	var player_position = player.global_position
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - player_position).normalized()
	var preview_position = player_position + direction * PLACEMENT_DISTANCE
	
	if current_preview_instance:
		current_preview_instance.position = preview_position
		current_preview_instance.rotation = player.rotation  # Obrne objekt tako kot igralca

func place_object():
	print("Trying to place object")
	if not can_place_object():
		print("Cannot place object: Placement check failed")
		return
	var new_object = null
	match selected_object_type:
		ObjectType.WOOD_WALL:
			new_object = WoodWallScene.instantiate()
			player.update_resources(WOOD_WALL_COST)
		ObjectType.STONE_WALL:
			new_object = StoneWallScene.instantiate()
			player.update_resources(STONE_WALL_COST)
		ObjectType.TRAP:
			new_object = TrapScene.instantiate()
			player.update_resources(TRAP_COST)
		ObjectType.TURRET:
			new_object = TurretScene.instantiate()
			player.update_resources(TURRET_COST)
	if new_object:
		print("New object instantiated")
		new_object.position = current_preview_instance.position
		new_object.rotation = current_preview_instance.rotation  # Obrne objekt tako kot predogled
		add_child(new_object)
		new_object.add_to_group("walls")  # Dodaj v skupino "walls"
		print("Object placed at: ", new_object.position)
		print("New wall parent: ", new_object.get_parent())  # Izpiši starša nove stene
		print_tree()  # Izpiši celotno drevo scene za pregled
		deselect_object()
	else:
		print("Failed to instantiate new object")

func can_place_object() -> bool:
	if not current_preview_instance:
		print("No current preview instance")
		return false
	if is_colliding_with_existing_object():
		print("Colliding with existing object")
		return false
	if not player.has_sufficient_resources(get_cost_for_selected_object()):
		print("Insufficient resources")
		return false
	return true

func get_cost_for_selected_object() -> Dictionary:
	match selected_object_type:
		ObjectType.WOOD_WALL:
			return WOOD_WALL_COST
		ObjectType.STONE_WALL:
			return STONE_WALL_COST
		ObjectType.TRAP:
			return TRAP_COST
		ObjectType.TURRET:
			return TURRET_COST
	return {}

func is_colliding_with_existing_object() -> bool:
	if not current_preview_instance:
		print("No current preview instance")
		return false

	var area = current_preview_instance.get_node("Area2D")
	var overlapping_bodies = area.get_overlapping_bodies()

	if overlapping_bodies.size() > 0:
		print("Collision detected with the following objects:")
		for body in overlapping_bodies:
			if body != current_preview_instance:
				print(" - ", body.name, " (", body, ")")
				return true

	return false

func _on_wall_removed(node_path):
	var node = get_node_or_null(node_path)
	if node:
		print("Wall still exists: ", node)
	else:
		print("Wall successfully removed from scene tree.")
