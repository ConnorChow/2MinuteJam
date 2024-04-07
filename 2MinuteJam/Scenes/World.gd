extends Node

@onready var OutsideMusic :AudioStreamPlayer= $MusicContainer/Outside


func _ready():
	GlobalController.restart()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)






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
	
func _on_strike_body_entered(_body):
	$MusicContainer/Node/Strike.play()
#** THE PIT **




#** Arcade **
func _on_arcade_off_body_entered(_body):
	if !OutsideMusic.playing:
		OutsideMusic.play()
	for musicChild in $MusicContainer/arcadeMusic.get_children():
		(musicChild as AudioStreamPlayer3D).stop()




func _on_arcade_on_body_entered(_body):
	OutsideMusic.stop()
	for musicChild in $MusicContainer/arcadeMusic.get_children():
		if !musicChild.playing:
			(musicChild as AudioStreamPlayer3D).play()
#** Arcade **


func _on_death_plane_body_entered(body):
	body.queue_free()





#** mall **
func _on_mall_on_body_entered(_body):
	if !$MusicContainer/mallMusic/mallMusic.playing:
		$MusicContainer/mallMusic/mallMusic.play()
	OutsideMusic.stop()
	pass # Replace with function body.


func _on_mall_off_body_entered(_body):
	$MusicContainer/mallMusic/mallMusic.stop()
	if !OutsideMusic.playing:
		OutsideMusic.play()
	
#** mall **
