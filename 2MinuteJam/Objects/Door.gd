extends RigidBody3D

var state : bool = false
@onready var animPlayer = $"../../AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("interact")

func interact(_node):
	#print("test")
	state = !state
	if state == false:
		animPlayer.play("close")
	else:
		animPlayer.play("open")
	
