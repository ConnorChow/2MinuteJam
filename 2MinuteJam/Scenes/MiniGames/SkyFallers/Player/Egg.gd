extends Area2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -=180 * delta
	$Sprite2D.rotation_degrees += 120* delta
	$CollisionShape2D.rotation_degrees += 60 * delta

func _ready():
	randomize()
	var i = randi_range(0,1)
	match i:
		0:$bloop1.play()
		1:$bloop2.play()
			
	




func _on_area_entered(area):
	get_parent().speedUP()
	area.queue_free()
	queue_free()
