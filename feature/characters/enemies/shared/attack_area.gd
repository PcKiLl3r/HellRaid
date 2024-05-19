extends Area2D

var damage: int = 0  # This will be set by the parent Enemy node

func _ready():
	# Connect the body_entered signal to a method using a callable
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	# Check if the entered body is the Player by comparing the group or name
	if body.is_in_group("Player"):
		print("Player entered attack area")
		if body.has_method("take_damage"):
			body.take_damage(damage)
		else:
			print("Player does not have take_damage method")
	else:
		print("Another body entered")
