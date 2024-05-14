extends Node2D

var direction = -1
var time : float = 1
@onready var chicken = preload("res://2MinuteJam/Scenes/MiniGames/SkyFallers/Enemy/Chicken.tscn")

var paused : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

 

func _on_timer_timeout():
	if !paused: get_tree().call_group("enemies", "direction", direction)
	$Timer.start(time)


func speedUP():
	$AudioStreamPlayer.play()
	time -= .03


func _on_area_2d_area_entered(_area):
	direction = -1
	get_tree().call_group("enemies", "down")


func _on_area_2d_2_area_entered(area):
	var c = chicken.instantiate()
	call_deferred("add_child", c) 
	c.global_position = area.global_position
	area.queue_free()
	


func _on_area_2d_3_area_entered(_area):
	direction = 1
	get_tree().call_group("enemies", "down")

