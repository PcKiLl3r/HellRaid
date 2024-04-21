extends Area2D

# Define the enum within a variable
enum ResourceType {IRON, STONE, WOOD}

# Export the enum type for editor selection, accessing the enum via the variable
@export var resource_type: ResourceType = ResourceType.IRON

func _ready():
	var area = self
	area.connect("body_entered", _on_body_entered)
	area.connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Player is near " + resource_type_to_string() + " deposit.")
				
func _on_body_exited(body):
	if body.is_in_group("Player"):
		print("Player has left the vicinity of " + resource_type_to_string() + " deposit.")

# Helper function to convert enum to string for printing
func resource_type_to_string():
	match resource_type:
		ResourceType.IRON:
			return "iron"
		ResourceType.STONE:
			return "stone"
		ResourceType.WOOD:
			return "wood"
		_:
			return "unknown"
