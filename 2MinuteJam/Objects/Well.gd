extends Node3D

var containsPlayer : bool = false
@onready var wellTimer = $wellTimer
var textPlace : int = 0
var wellText = [["Barking Sounds"], ["Whats that Lassie, someone fall down the Old Well?"], ["Hold on little one! Gravedigger George is on his way!"]
,["Digging sounds"] , ["So... What's your name.."], ["There is someone down here, right?"]]

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		containsPlayer = true
		wellTimer.start(randf_range(8.5, 25))



func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		containsPlayer = false
		wellTimer.stop()


func _on_well_timer_timeout():
	GlobalController.inDialogue = true
	get_tree().call_group("dialogue", "talking", wellText[textPlace])
	textPlace +=1
	wellTimer.start(randf_range(8.5, 25))


	
	
