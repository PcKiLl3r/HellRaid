extends CharacterBody2D

class_name Player

signal healthChanged
signal resourcesChanged
signal coinsChanged

@export var move_speed : float = 100
@export var max_health = 100
@export var damage_get = 50
@export var damage_give = 50
@export var attack_cooldown: float = 1.0
@export var knockback_force: float = 1

@onready var health: int = max_health
@onready var attack_area: Area2D = $AttackArea
@onready var attack_sound = $AttackSound
@onready var enemy_hit = $EnemyHit
@onready var player_hit = $PlayerHit
@onready var wood_hit = $WoodHit
@onready var stone_hit = $StoneHit
@onready var iron_hit = $IronHit

var initial_rotation = 0

var is_ready: bool = true

# Dictionary to store the player's resources
var resources = {
	"iron": 0,
	"stone": 0,
	"wood": 0
}

var coins: int = 0  # Player's coin count

var store_ui: Control = null

# Currently equipped weapon
var current_weapon: Node = null

func _ready():
	store_ui = get_node("/root/GameLevel/UserInterface/StoreUI")  # Adjust the path as needed
	if store_ui:
		store_ui.visible = false  # Initially hidden
		print("StoreUI found!")
	else:
		print("StoreUI not found!")

func _input(event):
	if event.is_action_pressed("toggle_store"):  # Define 'toggle_store' action in Input Map
		if store_ui:
			store_ui.visible = !store_ui.visible
			print("Toggled StoreUI visibility to ", store_ui.visible)
		else:
			print("StoreUI not found in _input()")

func _physics_process(_delta):
	look_at(get_global_mouse_position())
	
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	velocity = input_direction * move_speed
	
	if Input.is_action_just_pressed("attack") and is_ready:
		is_ready = false
		$CooldownTimer.start()
		initial_rotation = rotation_degrees
		play_attack_animation()
		check_attack_area()
		
	move_and_slide()

func play_attack_animation():
	#tween.kill()
	var tween = create_tween()
	
	rotation_degrees = initial_rotation
	attack_sound.play()
	
	tween.tween_property(self, "rotation_degrees", initial_rotation - 80, 0.1)
	tween.tween_property(self, "rotation_degrees", initial_rotation, 0.25)
	
func reset_rotation():
	rotation_degrees = initial_rotation
	
func take_damage(damage_get: int):
	health -= damage_get
	player_hit.play()
	if health < 0:
		health = 0
	emit_signal("healthChanged")
	if health <= 0:
		die()
	
func check_attack_area():
	var overlapping_bodies = attack_area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body is CharacterBody2D:
			var direction = (body.global_position - global_position).normalized()
			for child in body.get_children():
				if child is Damageable:
					enemy_hit.play()
					child.hit(damage_give, direction * knockback_force)
		# Check if the body is a resource deposit
		for child in body.get_children():
			if child.has_method("gather_resource"):
				child.gather_resource(self)
				break

func die():
	if health <= 0:
		print("Calling end game")
		get_tree().change_scene_to_file("res://feature/UI/overlays/game_over.tscn")

func _on_cooldown_timer_timeout():
	is_ready = true

# Method to add resources to the player's inventory
func add_resource(resource_type: String, amount: int):
	print("Gathering resource...")
	if resource_type in resources:
		resources[resource_type] += amount
		emit_signal("resourcesChanged")
		print("Added " + str(amount) + " " + resource_type)
		if resource_type == "wood":
			wood_hit.play()
		elif resource_type == "stone":
			stone_hit.play()
		elif resource_type == "iron":
			iron_hit.play()
			
# Method to add coins
func add_coins(amount: int):
	coins += amount
	emit_signal("coinsChanged")
	print("Added " + str(amount) + " coins. Total: " + str(coins))

# Method to load a weapon
func load_weapon(weapon_scene_path: String):
	if current_weapon:
		current_weapon.queue_free()  # Remove current weapon
	var weapon_scene = load(weapon_scene_path) as PackedScene
	if weapon_scene:
		current_weapon = weapon_scene.instantiate()
		add_child(current_weapon)
		current_weapon.position = Vector2(0, 0)  # Adjust as needed
		print("Loaded weapon: " + weapon_scene_path)


func has_sufficient_resources(cost: Dictionary) -> bool:
	for resource in cost.keys():
		if resources[resource] < cost[resource]:
			return false
	return true

func update_resources(cost: Dictionary):
	for resource in cost.keys():
		resources[resource] -= cost[resource]
	emit_signal("resourcesChanged")
