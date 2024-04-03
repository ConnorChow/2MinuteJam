extends RigidBody3D

@export var labelText : String
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("interact")
	$Label3D.set_text(labelText)
	pass # Replace with function body.
	
	
func interact(player : Node):
	match labelText:
		"Hands":
			player.hands.visible = true
			player.heldObject = null
			queue_free()
		"test":
			player.test.visible = true
			player.heldObject = null
			queue_free()
		"test2":
			player.test_2.visible = true
			player.heldObject = null
			queue_free()
		_:
			pass


