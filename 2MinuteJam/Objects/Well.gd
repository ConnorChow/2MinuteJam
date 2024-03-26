extends Node3D

var containsPlayer : bool = false
@onready var wellTimer = $wellTimer
var textPlace : int = 0

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
	get_tree().call_group("dialogue", "talking", wellDialogue())

func wellDialogue():
	wellTimer.start(randf_range(8.5, 25))
	match textPlace:
		0:
			textPlace +=1
			return "Barking Sounds"

		1:
			textPlace +=1
			return "Whats that Lassie, someone fall down the Old Well?"

		2:
			textPlace +=1
			return "Hold on little one! Gravedigger George is on his way!"

		3:
			textPlace +=1
			return "Digging sounds"

		4:
			textPlace +=1
			return "So... What's your name.."

		5:
			textPlace +=1
			return "There is someone down here, right?"

	
	
