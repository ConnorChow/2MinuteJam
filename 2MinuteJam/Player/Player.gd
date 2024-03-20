extends CharacterBody3D


const SENSITIVITY : float = 0.003
const SPEED : float = 4.5
const JUMP_VELOCITY : float = 4.0
const HITSTAGGER : float = 8.0 

var gravity : float = 9.8

var direction
var headDir

@onready var head = $Node3D
@onready var camera = $Node3D/Camera3D
@onready var interactBox = $Node3D/Camera3D/interactBox


# Get the gravity from the project settings to be synced with RigidBody nodes.

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	
	

func _input(event):
	if event is InputEventMouseMotion:
		if !GlobalController.inDialogue:
			head.rotate_y(-event.relative.x * SENSITIVITY)
			camera.rotate_x(-event.relative.y * SENSITIVITY)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
	
	
func _physics_process(delta):
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	headDir = (camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if Input.is_action_just_pressed("jump") and is_on_floor() && !GlobalController.inDialogue:
		velocity.y = JUMP_VELOCITY
	

	
	if Input.is_action_just_pressed("interact"):
		if interactBox.get_overlapping_bodies() != null:
			for body in interactBox.get_overlapping_bodies():
				print(body)
				if body.is_in_group("interact"):
					body.interact()
	if GlobalController.inDialogue:
		velocity = Vector3(0, -gravity*delta, 0)
	else:
		if is_on_floor():
			
			if direction:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 7)
				velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 7)
		if !is_on_floor() :
			velocity.y -= gravity * delta
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 3)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 3)

				
	
	move_and_slide()


