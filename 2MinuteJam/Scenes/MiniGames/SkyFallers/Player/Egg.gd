extends Area2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -=2
	$Sprite2D.rotation_degrees += 2
	$CollisionShape2D.rotation_degrees += 2





func _on_area_entered(area):
	area.queue_free()
	queue_free()
