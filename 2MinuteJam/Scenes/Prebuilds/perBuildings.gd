extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for i in get_children():
		i.rotation_degrees.y = (randi_range(0,4) * 90)

