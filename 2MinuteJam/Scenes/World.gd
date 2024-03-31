extends Node

@onready var OutsideMusic = $MusicContainer/Outside

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalController.restart()







func _on_outside_music_start_body_entered(_body):
	OutsideMusic.stop()


func _on_outside_music_start_body_exited(_body):
	OutsideMusic.play()

