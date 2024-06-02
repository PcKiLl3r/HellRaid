extends Area2D

var damage: int = 0  # This will be set by the parent Enemy node

func _ready():
	# Check if the signal is already connected before connecting
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))
		
	# Connect the body_entered signal to a method using a callable
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Player entered attack area")
		if body.has_method("take_damage"):
			body.take_damage(damage)
		else:
			print("Player does not have take_damage method")
	else:
		print("Another body entered")


func _on_area_entered(area):
	if area.is_in_group("walls"):
		print("Wall entered attack area")
		if area.has_method("decrease_health"):
			area.decrease_health(damage)
			if area.has_method("start_damage_timer"):
				area.start_damage_timer()
		else:
			print("Wall does not have decrease_health method")
	else:
		print("Another area entered")
