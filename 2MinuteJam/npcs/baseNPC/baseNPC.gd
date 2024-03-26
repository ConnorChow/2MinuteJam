extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var dialogue = ["Hello", "Good Bye", "beep", "boop"]


@export_enum("walks", "rolls", "falls") var moveType


var textPlace : int = 0
@onready var dialogueDetect = $playerDialogueDetector

func _ready():
	add_to_group("interact")


func _physics_process(delta):
	
	match moveType:
		"walks":
			#normal movement type
			pass
		"rolls":
			#rolling forward movement type
			pass
		"falls":
			# falls over and rolls on side movement type
			pass
	
	move_and_slide()

func interact():

	get_tree().call_group("dialogue", "talking", dialogue)
	


