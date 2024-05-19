extends Control

@onready var health_bar: ProgressBar = $ProgressBar

func _ready():
	if !health_bar:
		print("ProgressBar not found in HealthBar!")

# Function to set maximum health
func set_max_health(max_health):
	if health_bar:
		health_bar.max_value = max_health

# Function to update current health
func update_health(current_health):
	if health_bar:
		health_bar.value = current_health
