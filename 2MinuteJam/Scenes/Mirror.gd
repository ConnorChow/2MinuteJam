extends StaticBody3D

func _ready():
	add_to_group("interact")

func interact(_node):
	get_tree().change_scene_to_file("res://2MinuteJam/Scenes/SideScenes/Mirror.tscn")

