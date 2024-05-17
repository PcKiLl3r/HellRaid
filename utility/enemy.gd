extends CharacterBody2D
class_name Enemy  

@export var movement_speed = 125

@onready var player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	move_and_slide()
	look_at(player.global_position)
	rotation += PI / 2
