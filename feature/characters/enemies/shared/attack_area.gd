extends Area2D

func _ready():
	# Connect the area_entered signal to a method using a callable
	
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	# Check if the entered body is the Player by comparing the group or name
	if body.is_in_group("Player"):
		print("Player entered")
		body.hurtByEnemy(self)  # Assume this method exists in the Player's script
	else:
		print("Another body entered")
