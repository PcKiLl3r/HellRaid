extends Node2D

# This is the path to your weapons directory
const WEAPON_PATH = "res://feature/weapons/"

# Reference to the WeaponHolder node in your player scene
@onready var weapon_holder = $WeaponHolder

func _ready():
	var weapon_holder = get_node("WeaponHolder")
	if weapon_holder == null:
		print("WeaponHolder not found")
	else:
		print("WeaponHolder found: ", weapon_holder)

# Function to load a weapon by its name
func equip_weapon(weapon_name: String):
	# Remove the current weapon if there is one
	if weapon_holder.get_child_count() > 0:
		weapon_holder.get_child(0).queue_free()
	
	# Construct the full path to the weapon scene
	var weapon_scene_path = WEAPON_PATH + weapon_name + ".tscn"
	
	# Load the weapon scene
	var weapon_scene = load(weapon_scene_path)
	
	# Instance the weapon scene
	var weapon_instance = weapon_scene.instantiate()
	
	# Add the weapon instance to the WeaponHolder node
	weapon_holder.add_child(weapon_instance)

# Example function to equip a specific weapon (call this from your shop logic)
func on_buy_weapon():
	equip_weapon("Weapon")
	
	
