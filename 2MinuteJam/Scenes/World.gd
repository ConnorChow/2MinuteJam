extends Node

@onready var OutsideMusic :AudioStreamPlayer= $MusicContainer/Outside
var boredDialogue = ["Hey.", "You know you can leave the theater right?", "Like, I know it's a good film, but there's a ton more to see.", "Go check out the town."]
var moreBoredDialogue = ["Soo... You just want to sit here and watch this same two minute clip over and over?", "I really don't mind, but a lot of work went into building everything in this game.", "...", "Okay, well, let me know if you need anything."]
var mostBoredDialogue = ["Look, I've got stuff to do, and you probably have better stuff too. Like, you've been in here for over twenty minutues already.", "What enjoyment are you even getting by just sitting here?", "I don't get it.", "There's no secrets that I'm going to reveal, no greater meaning I'm going to unlock.", "...", "Okay, maybe just one secret."]
var secretBoredDialogue = ["This is a video game, I'm not actually talking to you right now.", "There, happy? Is that profound enough for you?", "Now, go explore the town."]

func _ready():
	GlobalController.restart()
	GlobalController.inTheater = true
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if GlobalController.timesInTheater == 3:
		get_tree().call_group("dialogue", "talking", boredDialogue)
	if GlobalController.timesInTheater == 6:
		get_tree().call_group("dialogue", "talking", moreBoredDialogue)
	if GlobalController.timesInTheater == 9:
		get_tree().call_group("dialogue", "talking", mostBoredDialogue)
	if GlobalController.timesInTheater == 12:
		get_tree().call_group("dialogue", "talking", secretBoredDialogue)





#collision layer 3 is dedicated for the player and things that detect them.
#There is no need to check hasMethod or isInGroup 

#** Theater **
func _on_outside_music_start_body_entered(_body):
	if !GlobalController.ending:
		OutsideMusic.stop()


func _on_outside_music_start_body_exited(_body):
	if !GlobalController.ending:
		OutsideMusic.play()
		GlobalController.inTheater = false
#** Theater**



#** THE PIT **
func _on_the_pit_outside_music_body_entered(_body):
	if !OutsideMusic.playing:
		OutsideMusic.play()


func _on_the_pit_music_off_body_entered(_body):
	OutsideMusic.stop()
	($MusicContainer/thePit/horrorSFX as AudioStreamPlayer).stop()
	$MusicContainer/thePit/horrorTimer.stop()
	
	

func _on_the_pit_music_on_body_entered(_body):
	# start the pit music
	$MusicContainer/thePit/horrorTimer.start()
	pass # Replace with function body.
	
func _on_strike_body_entered(_body):
	$MusicContainer/Node/Strike.play()
	


func _on_horror_timer_timeout():
	($MusicContainer/thePit/horrorSFX as AudioStreamPlayer).play()
	$MusicContainer/thePit/horrorTimer.start(randi_range(2,5))


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


# **fade out timer**
func _on_timer_timeout():
	$fadeOutControl/ColorRect/fadeOutAnim.play("fadeOut")
	pass # Replace with function body.

