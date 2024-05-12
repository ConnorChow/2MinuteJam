extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var curline : int = 0
@export var dialogue = [["Hello", "Good Bye", "beep", "boop"],["test", "test2"]]
@export var colour : Color
@export_enum("walks", "rolls", "falls", "not") var moveType  : String = "not"
@export var myName : String = "BaseNPC"

var textPlace : int = 0
@onready var dialogueDetect = $playerDialogueDetector
@onready var mesh = $MeshInstance3D


func _ready():
	var meshToColor = mesh.get_active_material(0)
	meshToColor.set_albedo(colour)
	add_to_group("interact")


func _physics_process(delta):
	
	match moveType:
		"walks":
			velocity.y -= gravity * delta
			velocity.z = lerpf(velocity.z, 0 , delta * 3)

		"rolls":
			#rolling forward movement type
			pass
		"falls":
			# falls over and rolls on side movement type
			pass
		_:
			pass
	if moveType != "not":
		
		move_and_slide()

func interact(_node):

	get_tree().call_group("dialogue", "talking", dialogue[curline], myName)
	if curline < dialogue.size()-1:
		curline +=1
	talkedTo()
	

func talkedTo():
	
	pass


