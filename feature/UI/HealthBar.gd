extends ProgressBar

@export var player: Player

func _ready():
	player.healthChanged.connect(self.update)  # Ensure this connection is correct
	update()  # Initial update to set the progress bar correctly

func update():
	value = player.health * 100 / player.max_health
