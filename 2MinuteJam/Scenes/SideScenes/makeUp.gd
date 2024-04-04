extends Sprite2D

var clickPos : Array = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _process(delta):
	if Input.is_action_pressed("throw"):
		clickPos.append(get_global_mouse_position ( ))
		queue_redraw()


func _draw():
	for point in clickPos:
		draw_circle(point, 10, Color.RED)
