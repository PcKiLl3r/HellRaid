extends Control

@onready var coin_label = $Panel/CoinLabel
@onready var speed_upgrade_button = $Panel/SpeedUpgradeButton
@onready var health_upgrade_button = $Panel/HealthUpgradeButton

func _ready():
	# Connect to the player's coin change signal
	var player = get_node("/root/GameLevel/Player")  # Adjust the path as needed
	player.connect("coinsChanged", _on_coins_changed)
	_on_coins_changed()  # Initialize with current coin count

	# Connect button signals
	speed_upgrade_button.connect("pressed", _on_speed_upgrade_button_pressed)
	health_upgrade_button.connect("pressed", _on_health_upgrade_button_pressed)

func _on_coins_changed():
	var player = get_node("/root/GameLevel/Player")  # Adjust the path as needed
	print("Updating coin label to " + str(player.coins))
	coin_label.text = "Coins: " + str(player.coins)

func _on_speed_upgrade_button_pressed():
	var player = get_node("/root/GameLevel/Player")  # Adjust the path as needed
	if player.coins >= 10:  # Example upgrade cost
		player.coins -= 10
		player.move_speed += 20  # Example upgrade
		player.coinsChanged.emit()
		print("Speed upgrade purchased!")
	else:
		print("Not enough coins!")

func _on_health_upgrade_button_pressed():
	var player = get_node("/root/GameLevel/Player")  # Adjust the path as needed
	if player.coins >= 20:  # Example upgrade cost
		player.coins -= 20
		player.max_health += 50  # Example upgrade
		player.current_health += 50  # Increase current health as well
		player.coinsChanged.emit()
		print("Health upgrade purchased!")
	else:
		print("Not enough coins!")
