extends Node
var ending : bool = false
#main menu streamer mode is very much appreciated
#screen shake if we use it
#possibly volume controls, I haven't bothered to learn that yet

var inDialogue : bool = false
var inTheater : bool = true
var timesInTheater : int = 0

@onready var restart_timer = $restartTimer

func restart():
	restart_timer.start()
	



func _on_timer_timeout():
	ending = true
	inDialogue = false
	#make this fancy then change to main menu
	if inTheater == true:
		timesInTheater +=1
	get_tree().change_scene_to_file("res://2MinuteJam/Scenes/World.tscn")
	ending = false

