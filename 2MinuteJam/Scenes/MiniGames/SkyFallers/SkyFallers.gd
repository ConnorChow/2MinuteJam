extends Node2D

var direction = -1
var time : float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

 

func _on_timer_timeout():
	get_tree().call_group("enemies", "direction", direction)
	$Timer.start(time)


func speedUP():
	$AudioStreamPlayer.play()
	time -= .03


func _on_area_2d_area_entered(area):
	direction *= -1
	get_tree().call_group("enemies", "down")
