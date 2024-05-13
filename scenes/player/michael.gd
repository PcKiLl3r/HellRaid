extends CharacterBody2D

class_name Player

signal healthChanged

@export var move_speed : float = 100
@export var max_health = 100
@onready var current_health: int = max_health

func _physics_process(_delta):
	look_at(get_global_mouse_position())
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	# Update velocity
	velocity = input_direction * move_speed

	# Move and slide function uses velocity of character body to move character
	move_and_slide()

func hurtByEnemy(area):
	current_health -= 20
	if current_health <= 0:
		current_health = 0  # Keep health at zero instead of resetting it to max_health
		# Consider adding a death or reset function here if needed
	healthChanged.emit()
