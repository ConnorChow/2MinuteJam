extends Area2D

var moveTo : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = lerp(global_position, moveTo, delta*3)
	pass


func _on_timer_timeout():
	moveTo = Vector2(randf_range(590,1133), randf_range(30,610))
