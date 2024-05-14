extends StaticBody3D
@onready var camera = $"../ArceggMachine/Camera3D"
@onready var sub_viewport = $"../ArceggMachine/SubViewport"
@onready var world = $"../ArceggMachine/SubViewport/World" as Node2D

@export var arcade_scene : PackedScene


func _process(_delta):
	if !camera.current and world.get_child_count() > 0:
		#print("destroy")
		for game in world.get_children():
			game.paused = true

func interact(node):
	if !camera.current:
		node.inMinigame = true
		camera.make_current()
		for game in world.get_children():
			game.paused = false

func add_game():
	var game = arcade_scene.instantiate()
	game.owner = get_tree().root
	world.add_child(game)
