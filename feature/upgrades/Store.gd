extends Control

@onready var coin_label = $Panel/CoinLabel
@onready var speed_upgrade_button = $Panel/SpeedUpgradeButton
@onready var health_upgrade_button = $Panel/HealthUpgradeButton
@onready var weapon1_button = $Panel/Weapon1Button
@onready var weapon2_button = $Panel/Weapon2Button
@onready var weapon3_button = $Panel/Weapon3Button
@onready var weapon4_button = $Panel/Weapon4Button

func _ready():
	# Connect to the player's coin change signal
	var player = get_node("/root/GameLevel/Player")  # Adjust the path as needed
	player.connect("coinsChanged", _on_coins_changed)
	_on_coins_changed()  # Initialize with current coin count

	# Connect button signals
	speed_upgrade_button.connect("pressed", _on_speed_upgrade_button_pressed)
	health_upgrade_button.connect("pressed", _on_health_upgrade_button_pressed)
	weapon1_button.connect("pressed", _on_weapon1_button_pressed)
	weapon2_button.connect("pressed", _on_weapon2_button_pressed)
	weapon3_button.connect("pressed", _on_weapon3_button_pressed)
	weapon4_button.connect("pressed", _on_weapon4_button_pressed)

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
		player.health += 50  # Increase current health as well
		player.coinsChanged.emit()
		print("Health upgrade purchased!")
	else:
		print("Not enough coins!")

# Functions to load weapons
func _on_weapon1_button_pressed():
	var player = get_node("/root/GameLevel/Player")  # Adjust the path as needed
	if player.coins >= 20:  # Example upgrade cost
		player.coins -= 20
		player.damage_give = 34
		player.knockback_force = 1.30
		player.load_weapon("res://feature/weapons/weapon_1.tscn")
		player.coinsChanged.emit()
		print("Weapon 1 equiped")
	else:
		print("Not enough coins!")

func _on_weapon2_button_pressed():
	var player = get_node("/root/GameLevel/Player")  # Adjust the path as needed
	if player.coins >= 50:  # Example upgrade cost
		player.coins -= 50
		player.damage_give = 50
		player.knockback_force = 0.75
		player.load_weapon("res://feature/weapons/weapon_2.tscn")
		player.coinsChanged.emit()
		print("Weapon 1 equiped")
	else:
		print("Not enough coins!")

func _on_weapon3_button_pressed():
	var player = get_node("/root/GameLevel/Player")  # Adjust the path as needed
	if player.coins >= 100:  # Example upgrade cost
		player.coins -= 100
		player.damage_give = 100
		player.attack_cooldown = 1.2
		player.knockback_force = 1
		player.load_weapon("res://feature/weapons/weapon_3.tscn")
		player.coinsChanged.emit()
		print("Weapon 1 equiped")
	else:
		print("Not enough coins!")

func _on_weapon4_button_pressed():
	var player = get_node("/root/GameLevel/Player")  # Adjust the path as needed
	if player.coins >= 100:  # Example upgrade cost
		player.coins -= 100
		player.damage_give = 75
		player.attack_cooldown = 0.4
		player.knockback_force = 0.75
		player.load_weapon("res://feature/weapons/weapon_4.tscn")
		player.coinsChanged.emit()
		print("Weapon 1 equiped")
	else:
		print("Not enough coins!")
