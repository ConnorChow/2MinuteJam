extends RigidBody3D

@onready var audio_stream_player_3d :AudioStreamPlayer3D= $AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_colliding_bodies():
		if !get_colliding_bodies().is_empty():
			if get_angular_velocity().length() > 5 || get_linear_velocity().length() > 4.5:
				audio_stream_player_3d.play()


