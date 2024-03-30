extends Camera3D

var marker = preload("res://2MinuteJam/Scenes/MiniGames/RailShooter/Player/Marker.tscn")

func _input(event):
	if event.is_action_pressed("throw"):
		shoot_ray()
		
func shoot_ray():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	var raycast_result = space.intersect_ray(ray_query)
	
	if !raycast_result.is_empty():
		var i = marker.instantiate()
		i.position = raycast_result["position"]
		$'../../../'.add_child(i)
	
	
	
	

