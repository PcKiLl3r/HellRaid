extends Node

class_name Damageable

@export var health: int = 100
@export var max_health: int = 100
@export var coins: int = 10  # Number of coins this enemy drops

var health_bar: Control

func _ready():
	# Defer initialization to ensure nodes are available
	call_deferred("_initialize_health_bar")

func _initialize_health_bar():
	# Access HealthBar using a relative path from the parent
	health_bar = get_parent().get_node("HealthBar") as Control
	
	if health_bar:
		health_bar.set_max_health(max_health)
		health_bar.update_health(health)
	else:
		print("HealthBar not found!")

func hit(damage: int):
	health -= damage
	if health < 0:
		health = 0
	if health_bar:
		health_bar.update_health(health)
	else:
		print("Cannot update HealthBar because it's not found.")
	if health <= 0:
		die()

func die():
	var player = get_node("/root/GameLevel/Player")  # Adjust the path as needed
	if player:
		player.add_coins(coins)
	get_parent().queue_free()
