extends Node

@onready var OutsideMusic :AudioStreamPlayer= $MusicContainer/Outside

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalController.restart()






#collision layer 3 is dedicated for the player and things that detect them.
#There is no need to check hasMethod or isInGroup 

#** Theater **
func _on_outside_music_start_body_entered(_body):
	if !GlobalController.ending:
		OutsideMusic.stop()


func _on_outside_music_start_body_exited(_body):
	if !GlobalController.ending:
		OutsideMusic.play()
#** Theater**


#** THE PIT **
func _on_the_pit_outside_music_body_entered(_body):
	if !OutsideMusic.playing:
		OutsideMusic.play()


func _on_the_pit_music_off_body_entered(_body):
	OutsideMusic.stop()
	

func _on_the_pit_music_on_body_entered(_body):
	# start the pit music
	pass # Replace with function body.
#** THE PIT **



