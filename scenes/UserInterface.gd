extends CanvasLayer

@onready var game_timer = $GameTimer
@onready var time_label = $TimeLabel  # Ensure this is correct based on your scene hierarchy
var seconds_passed = 0

func _ready():
	game_timer.connect("timeout", Callable(self, "_on_GameTimer_timeout"))

func _on_GameTimer_timeout():
	Globals.time_survived += 1
	# Update your UI with the elapsed time
	time_label.text = "Time: " + str(Globals.time_survived)
