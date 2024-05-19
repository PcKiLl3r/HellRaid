extends CharacterBody2D

class_name Player

signal healthChanged
signal resourcesChanged
signal coinsChanged

@export var move_speed : float = 100
@export var max_health = 100
@export var damage = 50
@export var attack_cooldown: float = 1.0
@onready var health: int = max_health
@onready var attack_area: Area2D = $AttackArea

var initial_rotation = 0
var tween = Tween.new()
var is_ready: bool = true

# Dictionary to store the player's resources
var resources = {
	"iron": 0,
	"stone": 0,
	"wood": 0
}

var coins: int = 0  # Player's coin count

var store_ui: Control = null

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
	tween.kill()
	tween = create_tween()
	
	rotation_degrees = initial_rotation
	
	tween.tween_property(self, "rotation_degrees", initial_rotation - 80, 0.1)
	tween.tween_property(self, "rotation_degrees", initial_rotation, 0.25)
	
func reset_rotation():
	rotation_degrees = initial_rotation
	
func take_damage(damage: int):
	health -= damage
	print("Player took damage: health reduced to ", health)
	if health < 0:
		health = 0
	emit_signal("healthChanged")
	if health <= 0:
		die()
	
func check_attack_area():
	var overlapping_bodies = attack_area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body is CharacterBody2D:
			for child in body.get_children():
				if child is Damageable:
					print("Player hit for: " + str(damage))
					child.hit(damage)
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

# Method to add coins
func add_coins(amount: int):
	coins += amount
	emit_signal("coinsChanged")
	print("Added " + str(amount) + " coins. Total: " + str(coins))
