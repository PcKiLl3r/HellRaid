extends CharacterBody2D

class_name Player

signal healthChanged

@export var move_speed : float = 100
@export var max_health = 100
@export var damage = 50
@export var attack_cooldown: float = 1.0
@onready var current_health: int = max_health
@onready var attack_area: Area2D = $AttackArea

var initial_rotation = 0
var tween = Tween.new()
var is_ready: bool = true

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
	
func hurtByEnemy(_area):
	current_health -= 20
	print("Health changed")
	if current_health <= 0:
		current_health = 0  # Keep health at zero instead of resetting it to max_health
		# Consider adding a death or reset function here if needed
	healthChanged.emit()
	die()
	

func check_attack_area():
	var overlapping_bodies = attack_area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body is CharacterBody2D:
			for child in body.get_children():
				if child is Damageable:
					#print("Hit for: " + damage)
					child.hit(damage)

func die():
	if current_health <= 0:
		get_tree().change_scene_to_file("res://utility/game_over.tscn")


func _on_cooldown_timer_timeout():
	is_ready = true
