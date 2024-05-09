extends Node

# Boids move in random directions, only veering towards the centre if they get too far away. They will have 3 rules:
# 	1: They steer away from any nearby boids to avoid crashing into them
# 	2: Move in same direction as nearby boids
# 	3: Steer towards the center of any nearby boids

@export var boids_radius : float = 16

@export_group("Fish")
@export var fish_mesh : Mesh
@export var num_fish : int = 128
@export var fish_speed : float = 1
@export var fish_direction_speed : float = 1
@export var direction_change_delay : float = 1.0
@export var fish_streamline_direction : Vector3 = Vector3(0, 0, 1)
@export var fish_chunk_size : float = 8
@export var fish_neighbor_radius : float = 4
var fish_heading : PackedVector3Array
var fish_desired_direction : PackedVector3Array
var fish_direction_change_timer : PackedFloat32Array
var fish_current_grid : PackedVector3Array
var fish_multimesh : MultiMesh

@export_group("Shorks")
@export var shork_mesh : Mesh
@export var max_shorks : int = 64
var current_sharks : int = 0
var shork_desired_direction : PackedVector3Array
var shork_current_grid : PackedVector3Array
var shork_multimesh : MultiMesh

var thread : Thread


# Called when the node enters the scene tree for the first time.
func _ready():
	thread = Thread.new()
	
	var fish_multimesh_instance : MultiMeshInstance3D = MultiMeshInstance3D.new()
	add_child(fish_multimesh_instance)
	fish_multimesh_instance.owner = get_tree().root
	
	fish_multimesh = MultiMesh.new()
	fish_multimesh_instance.multimesh = fish_multimesh
	
	fish_multimesh.mesh = fish_mesh
	fish_multimesh.use_custom_data = true
	
	fish_multimesh.transform_format = MultiMesh.TRANSFORM_3D
	
	fish_multimesh.instance_count = num_fish
	print(fish_multimesh.instance_count)
	#fish_multimesh.visible_instance_count = num_fish
	fish_heading.resize(num_fish)
	fish_desired_direction.resize(num_fish)
	fish_direction_change_timer.resize(num_fish)
	
	for i in range(0, num_fish):
		var position : Vector3 = Vector3.ZERO.direction_to(Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))) * randf_range(0, boids_radius)
		fish_desired_direction[i] = Vector3.ZERO.direction_to(Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)))
		fish_heading[i] = fish_desired_direction[i]
		fish_direction_change_timer[i] = randf_range(0, direction_change_delay)
		
		fish_multimesh.set_instance_transform(i, Transform3D(Basis.IDENTITY, position))
		fish_multimesh.set_instance_custom_data(i, Color(randf(), 0, 0))
	
	var shork_multimesh_instance : MultiMeshInstance3D = MultiMeshInstance3D.new()
	add_child(shork_multimesh_instance)
	shork_multimesh_instance.owner = get_tree().root
	
	shork_multimesh = MultiMesh.new()
	shork_multimesh_instance.multimesh = shork_multimesh
	
	shork_multimesh.mesh = shork_mesh
	shork_multimesh.use_custom_data = true
	
	shork_multimesh.transform_format = MultiMesh.TRANSFORM_3D
	
	shork_multimesh.instance_count = max_shorks
	shork_multimesh.visible_instance_count = 0

func _fish_movement_process(index : int, delta):
	var fish_transform_in : Transform3D = fish_multimesh.get_instance_transform(index)
	var fish_pos : Vector3 = fish_transform_in.origin
	
	fish_direction_change_timer[index] -= delta
	if fish_direction_change_timer[index] <= 0:
		if Vector3.ZERO.distance_to(fish_pos) > boids_radius:
			fish_desired_direction[index] = fish_pos.direction_to(Vector3.ZERO)
		else:
			fish_desired_direction[index] = Vector3.ZERO.direction_to(Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)))
		fish_direction_change_timer[index] = direction_change_delay
	
	if fish_desired_direction[index].distance_to(fish_heading[index]) > 0.05:
		fish_heading[index] += fish_heading[index].direction_to(fish_desired_direction[index]) * delta * fish_direction_speed
		fish_heading[index] = Vector3.ZERO.direction_to(fish_heading[index])
	else:
		fish_heading[index] = fish_desired_direction[index]
	
	fish_pos += fish_heading[index] * fish_speed * delta
	
	var new_transform : Transform3D = Transform3D(Basis.IDENTITY, fish_pos)
	var rotate_axis : Vector3 = fish_streamline_direction.cross(fish_heading[index]).normalized()
	var angle : float = fish_streamline_direction.angle_to(fish_heading[index])
	
	var fish_transform_out : Transform3D = new_transform.rotated_local(rotate_axis, angle)#.scaled_local(Vector3.ONE * 0.25)
	
	fish_multimesh.set_instance_transform(index, fish_transform_out)

var neighbors : PackedVector3Array = [
	Vector3i(1, 1, 1),
	Vector3i(0, 1, 1),
	Vector3i(-1, 1, 1),
	Vector3i(1, 0, 1),
	Vector3i(0, 0, 1),
	Vector3i(-1, 0, 1),
	Vector3i(1, -1, 1),
	Vector3i(0, -1, 1),
	Vector3i(-1, -1, 1),
	Vector3i(1, 1, 0),
	Vector3i(0, 1, 0),
	Vector3i(-1, 1, 0),
	Vector3i(1, 0, 0),
	Vector3i(-1, 0, 0),
	Vector3i(1, -1, 0),
	Vector3i(0, -1, 0),
	Vector3i(-1, -1, 0),
	Vector3i(1, 1, -1),
	Vector3i(0, 1, -1),
	Vector3i(-1, 1, -1),
	Vector3i(1, 0, -1),
	Vector3i(0, 0, -1),
	Vector3i(-1, 0, -1),
	Vector3i(1, -1, -1),
	Vector3i(0, -1, -1),
	Vector3i(-1, -1, -1)]

func _find_fish_in_radius(chunk_library : Dictionary, current_fish : int) -> PackedInt32Array:
	var nearby_fish_list : PackedInt32Array
	var current_pos : Vector3 = fish_multimesh.get_instance_transform(current_fish).origin
	
	var current_chunk : Vector3i = floor(current_pos / fish_chunk_size) as Vector3i
	var current_chunk_position : Vector3 = (current_chunk as Vector3) * fish_chunk_size
	
	var chunks_to_search : Array = [current_chunk]
	
	for direction : Vector3i in neighbors:
		if !chunk_library.has(current_chunk + direction): continue
		var neighboring_chunk : Vector3i = current_chunk + direction
		var neighboring_chunk_position : Vector3 = (neighboring_chunk as Vector3) * fish_chunk_size
		
		var has_x_overlap : bool = abs(current_pos.x - neighboring_chunk_position.x) > fish_neighbor_radius
		var has_y_overlap : bool = abs(current_pos.y - neighboring_chunk_position.y) > fish_neighbor_radius
		var has_z_overlap : bool = abs(current_pos.z - neighboring_chunk_position.z) > fish_neighbor_radius
		
		if has_x_overlap or has_y_overlap or has_z_overlap:
			chunks_to_search.append(neighboring_chunk)
	
	for chunk in chunks_to_search:
		var fish_list : PackedInt32Array = (chunk_library[chunk] as Array).duplicate() as PackedInt32Array
		
		for fish_index in fish_list:
			var fish_pos : Vector3 = fish_multimesh.get_instance_transform(fish_index).origin
			if current_pos.distance_to(fish_pos) <= fish_neighbor_radius and fish_heading[current_fish].angle_to(current_pos.direction_to(fish_pos)) > 1:
				nearby_fish_list.append(fish_index)
	
	return nearby_fish_list

# Called every frame. 'delta' is the elapsed time since the previous frame.pass#
func _process(delta):
	var chunk_library : Dictionary
	
	for index in range(0, num_fish):
		var fish_pos : Vector3 = fish_multimesh.get_instance_transform(index).origin
		var chunk : Vector3i = floor(fish_pos / fish_chunk_size) as Vector3i
		
		if chunk_library.has(chunk):
			(chunk_library[chunk] as Array).append(index)
		else:
			chunk_library[chunk] = [index]
	
	# Iterate through all the fish
	for index in range(0, num_fish):
		var fish_transform_in : Transform3D = fish_multimesh.get_instance_transform(index)
		var fish_pos : Vector3 = fish_transform_in.origin
		
		fish_direction_change_timer[index] -= delta
		if fish_direction_change_timer[index] <= 0:
			if Vector3.ZERO.distance_to(fish_pos) > boids_radius:
				fish_desired_direction[index] = fish_pos.direction_to(Vector3.ZERO)
			else:
				fish_desired_direction[index] = Vector3.ZERO.direction_to(Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)))
			fish_direction_change_timer[index] = direction_change_delay
		
		if fish_desired_direction[index].distance_to(fish_heading[index]) > 0.05:
			fish_heading[index] += fish_heading[index].direction_to(fish_desired_direction[index]) * delta * fish_direction_speed
			fish_heading[index] = Vector3.ZERO.direction_to(fish_heading[index])
		else:
			fish_heading[index] = fish_desired_direction[index]
		
		var nearby_fish : PackedInt32Array = _find_fish_in_radius(chunk_library, index)
		if nearby_fish.size() > 0:
			var closest_fish_pos : Vector3 = fish_pos + (Vector3.ONE * fish_chunk_size)
			var closest_distance : float = fish_chunk_size
			var closest_index : int
			
			for nearby_fish_index : int in nearby_fish:
				# Find the closest fish to the player
				var nearby_fish_pos : Vector3 = fish_multimesh.get_instance_transform(nearby_fish_index).origin
				var nearby_fish_distance : float = nearby_fish_pos.distance_to(fish_pos)
				if nearby_fish_distance < closest_distance:
					closest_distance = nearby_fish_distance
					closest_fish_pos = nearby_fish_pos
					closest_index = nearby_fish_index
			
			var direction_to_nearest : Vector3 = fish_pos.direction_to(closest_fish_pos)
			
			var closest_neighbor_direction : Vector3 = fish_heading[closest_index]
			var direction_to_neighbor_direction : Vector3 = fish_heading[index].direction_to(closest_neighbor_direction)
			
			fish_heading[index] +=(direction_to_neighbor_direction * delta * 0.25)
			
			var towards_nearest_center : Vector3 = fish_heading[index].direction_to(closest_fish_pos)
			
			fish_heading[index] += (towards_nearest_center * delta * 0.25)
			
			var obstructivenesas : float = fish_heading[index].angle_to(direction_to_nearest)
			var axis : Vector3 = -fish_heading[index].cross(fish_heading[index]).normalized()
			
			if obstructivenesas > 1:
				var desired_avoid_direction : Vector3 = fish_heading[index].rotated(axis.normalized(), obstructivenesas * delta * 10)
				var direction_to_desired : Vector3 = fish_heading[index].direction_to(desired_avoid_direction)
				fish_heading[index] += direction_to_desired * delta * 0.125
		
		fish_pos += fish_heading[index] * fish_speed * delta
		
		var new_transform : Transform3D = Transform3D(Basis.IDENTITY, fish_pos)
		var rotate_axis : Vector3 = fish_streamline_direction.cross(fish_heading[index]).normalized()
		var angle : float = fish_streamline_direction.angle_to(fish_heading[index])
		
		var fish_transform_out : Transform3D = new_transform.rotated_local(rotate_axis, angle)#.scaled_local(Vector3.ONE * 0.25)
		
		fish_multimesh.set_instance_transform(index, fish_transform_out)

func _exit_tree():
	pass
	#thread.wait_to_finish()
