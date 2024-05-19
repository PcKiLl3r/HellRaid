extends Control

@onready var iron_label = $Node2DIron/LabelIron
@onready var stone_label = $Node2DStone/LabelStone
@onready var wood_label = $Node2DWood/LabelWood

func _ready():
	# Connect to the player's resource change signal
	var player = get_node("/root/GameLevel/Player")  # Adjust the path as needed
	player.connect("resourcesChanged", _on_resources_changed)
	_on_resources_changed()  # Initialize with current resource values

# Method to update resource counts in the UI
func _on_resources_changed():
	var player = get_node("/root/GameLevel/Player")  # Adjust the path as needed
	iron_label.text = str(player.resources["iron"])
	stone_label.text = str(player.resources["stone"])
	wood_label.text = str(player.resources["wood"])