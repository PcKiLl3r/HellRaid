extends CharacterBody2D

@export var move_speed : float = 100

func _physics_process(_delta):
	look_at(get_global_mouse_position())
	# Get input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	#Update velocity
	velocity = input_direction * move_speed

	#Move and slide function uses velocity of character body to move character
	move_and_slide()
