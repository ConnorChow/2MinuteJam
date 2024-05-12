extends RigidBody2D

var initial_velocity : float = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = Vector2(initial_velocity if randf() > 0.5 else -initial_velocity, (initial_velocity if randf() > 0.5 else -initial_velocity)/2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var direction = global_position.direction_to(global_position + linear_velocity)
	linear_velocity = direction * initial_velocity
	if linear_velocity.x > 0:
		linear_velocity.x = initial_velocity
	else:
		linear_velocity.x = -initial_velocity
