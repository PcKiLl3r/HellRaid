extends Control

@onready var health_bar: ProgressBar = $ProgressBar

func _ready():
	if !health_bar:
		print("ProgressBar not found in HealthBar!")
	else:
		var damageable = get_parent().get_node("Damageable")  # Adjust the path as needed
		if damageable:
			health_bar.max_value = damageable.max_health
			health_bar.value = damageable.health
			damageable.connect("health_changed", _on_health_changed)
			damageable.connect("died", _on_died)
			print("Connected to Damageable: ", damageable)

func _on_health_changed(current_health):
	if health_bar:
		health_bar.value = current_health
		print("HealthBar updated: ", current_health)

func _on_died():
	print("Enemy died, HealthBar removed")
	queue_free()
