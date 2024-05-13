extends ProgressBar

@export var player: Player

func ready():
	player.healthChanged.connect((update))
	update()

func update():
	value = player.current_health * 100 / player.max_health
