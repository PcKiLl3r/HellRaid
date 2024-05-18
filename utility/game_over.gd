extends CanvasLayer

@onready var time_label = $TimeSurvivedLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	var time_survived = Globals.time_survived
	time_label.text = "Time Survived: " + str(time_survived) + " seconds"


func _on_retry_pressed():
	get_tree().change_scene_to_file("res://scenes/game_level.tscn")


func _on_quit_pressed():
	get_tree().quit()
