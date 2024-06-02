extends Area2D

@export var max_health: int = 200
@export var damage_interval: float = 2.0  # Interval za zmanjšanje življenjskih točk
@export var damage_per_tick: int = 10  # Poškodba na vsak interval

var current_health: int

signal wall_removed(node_path)

func _ready():
	current_health = max_health
	update_health_display()
	
	# Nastavi timer
	$Timer.wait_time = damage_interval
	$Timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	#print("Wall is ready with health: %d" % current_health)

func decrease_health(damage: int):
	current_health -= damage
	#print("Wall health decreased by %d, current health: %d" % [damage, current_health])
	update_health_display()
	if current_health <= 0:
		print("Wall health is 0 or less. Removing wall.")
		remove_wall()

func update_health_display():
	$Label.text = str(current_health)

func _on_Timer_timeout():
	decrease_health(damage_per_tick)

func start_damage_timer():
	$Timer.start()

func stop_damage_timer():
	$Timer.stop()

func remove_wall():
	print("Attempting to remove wall.")
	var root_node = get_parent().get_parent()  # Predpostavljamo, da je Area2D otrok StaticBody2D
	var node_path = root_node.get_path()  # Pridobimo pot glavnega vozlišča
	emit_signal("wall_removed", node_path)
	root_node.queue_free()
