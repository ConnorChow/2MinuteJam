extends CharacterBody3D


const SENSITIVITY : float = 0.003
const SPEED : float = 4.5
const runSpeed : float = 1.5
var modSpeed : float
const JUMP_VELOCITY : float = 4.0
const HITSTAGGER : float = 8.0 

var gravity : float = 9.8

var direction
var headDir

var heldObject : Object

@onready var head = $Node3D
@onready var camera = $Node3D/Camera3D
@onready var interactBox = $Node3D/Camera3D/interactBox
@onready var holdPoint = $Node3D/Camera3D/holdPoint

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
	
	if heldObject:
		heldObject.global_position = holdPoint.global_position
		if Input.is_action_pressed("ctrl") && Input.is_action_just_pressed("mwu"):
			heldObject.rotate_x(.3)
			#heldObject.transform.basis.x += Vector3(.3, 0, 0)
			#heldObject.rotation.x +=.3
			#if heldObject.rotation_degrees.x >= deg_to_rad(359):
			#	heldObject.rotation_degrees.x= deg_to_rad(0)
		elif Input.is_action_just_pressed("mwu"):
			heldObject.rotate_y(.3)
			#heldObject.transform.basis.y +=Vector3(0, .3, 0)
			#heldObject.rotation.y +=.3
			
		if Input.is_action_pressed("ctrl") && Input.is_action_just_pressed("mwd"):
			heldObject.rotate_x(-.3)
			#heldObject.transform.basis.x -=Vector3(.3, 0, 0)
			#heldObject.rotation.x -=.3
			#if heldObject.rotation_degrees.x >= deg_to_rad(1):
			#	heldObject.rotation_degrees.x= deg_to_rad(360)
		elif Input.is_action_just_pressed("mwd"):
			heldObject.rotate_y(-.3)
			#heldObject.transform.basis.y +=Vector3(0, .3, 0)
			#heldObject.rotation.y -=.3
	if Input.is_action_pressed("shift"):
		modSpeed = SPEED + runSpeed
	if Input.is_action_just_released("shift"):
		modSpeed = SPEED
			
	if Input.is_action_just_pressed("interact"):
		if interactBox.get_overlapping_bodies() != null:
			for body in interactBox.get_overlapping_bodies():
				print(body)
				if !heldObject:
					if body.is_in_group("pickable"):
						heldObject = body
						heldObject.collision_mask = 0
						heldObject.set_sleeping(true)
				elif heldObject:
					heldObject.set_sleeping(false)
					heldObject.collision_mask = 1
					heldObject = null
	#				heldObject.mode = RigidBody3D.FREEZE_MODE_KINEMATIC
				if body.is_in_group("interact"):
					body.interact()
	if GlobalController.inDialogue:
		velocity = Vector3(0, -gravity*delta, 0)
	else:
		if is_on_floor():
			
				
			if direction:
				velocity.x = direction.x * modSpeed
				velocity.z = direction.z * modSpeed
			else:
				velocity.x = lerp(velocity.x, direction.x * modSpeed, delta * 7)
				velocity.z = lerp(velocity.z, direction.z * modSpeed, delta * 7)
		if !is_on_floor() :
			velocity.y -= gravity * delta
			velocity.x = lerp(velocity.x, direction.x * modSpeed, delta * 3)
			velocity.z = lerp(velocity.z, direction.z * modSpeed, delta * 3)

				
	velocity.normalized()
	move_and_slide()


