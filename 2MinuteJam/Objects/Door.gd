extends RigidBody3D

var state : bool = true
@onready var animPlayer = $"../../AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("interact")

func interact():
	print("test")
	state = !state
	if state == false:
		animPlayer.play("close")
	else:
		animPlayer.play("open")
	
