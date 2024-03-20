extends Node

#main menu streamer mode is very much appreciated
#screen shake if we use it
#possibly volume controls, I haven't bothered to learn that yet

var inDialogue : bool = false

func _ready():
	
	pass


func restart():
	await get_tree().create_timer(120).timeout
	#make this fancy then change to main menu
	get_tree().change_scene_to_file("res://2MinuteJam/Scenes/World.tscn")

