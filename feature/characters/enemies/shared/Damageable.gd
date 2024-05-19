extends Node
class_name Damageable

@export var health: int = 100
@export var max_health: int = 100
@export var coins: int = 10  # Number of coins this enemy drops

signal health_changed(current_health)
signal died
signal knocked_back(direction)

func _ready():
	health = max_health
	emit_signal("health_changed", health)
	print("Damageable ready: health initialized to ", health)

func hit(damage: int, knockback_direction: Vector2):
	health -= damage
	print("Damageable hit: health reduced to ", health)
	if knockback_direction != Vector2.ZERO:
		emit_signal("knocked_back", knockback_direction)
	if health < 0:
		health = 0
	emit_signal("health_changed", health)
	print("Damageable health changed: current health is ", health)
	if health <= 0:
		die()

func die():
	print("Damageable died")
	var player = get_node("/root/GameLevel/Player")  # Adjust the path as needed
	if player:
		player.add_coins(coins)
	emit_signal("died")
	call_deferred("queue_free")  # Use call_deferred to queue the node for removal
