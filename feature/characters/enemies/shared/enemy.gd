extends CharacterBody2D
class_name Enemy  

@export var movement_speed = 125
@export var attack_damage = 10
@export var attack_speed = 1.0  # Attacks per second
@export var attack_range = 100  # Range within which the enemy can attack the player

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var attack_timer = Timer.new()
@onready var damageable = $Damageable
@onready var attack_area = $AttackArea  # Adjust the path as needed

func _ready():
	add_child(attack_timer)
	attack_timer.wait_time = 1.0 / attack_speed
	attack_timer.connect("timeout", _on_attack_timer_timeout)

	# Connect to the died signal of the Damageable component
	if damageable:
		damageable.connect("died", _on_died)
		print("Enemy connected to Damageable died signal")

	# Pass the enemy's damage to the attack area
	if attack_area:
		attack_area.damage = attack_damage

func _physics_process(delta):
	if player and damageable and damageable.health > 0:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * movement_speed
		move_and_slide()
		look_at(player.global_position)
		rotation += PI / 2

		if attack_timer.is_stopped():
			attack_timer.start()

func _on_attack_timer_timeout():
	if player and damageable and damageable.health > 0 and global_position.distance_to(player.global_position) <= attack_range:
		attack()

func attack():
	if player.has_method("take_damage"):
		print("Enemy attacking player")
		player.take_damage(attack_damage)

func _on_died():
	# Stop the enemy from attacking after it dies
	print("Enemy received died signal")
	if attack_timer.is_connected("timeout", _on_attack_timer_timeout):
		attack_timer.stop()
		attack_timer.disconnect("timeout", _on_attack_timer_timeout)

	# Optionally, you can disable the enemy's movement and other actions here
	set_process(false)  # Disable the _physics_process method
	set_physics_process(false)  # Disable physics processing
	queue_free()
