extends CharacterBody3D


const SENSITIVITY : float = 0.003
const SPEED : float = 4.5
const runSpeed : float = 1.5
var modSpeed : float
const JUMP_VELOCITY : float = 4.2
const pushForce : float = 2

var gravity : float = 9.8

var canleave: bool = true
var sitting : bool = false
var inMinigame : bool = false

var direction
var headDir

var heldObject : Object
var hitObject :Object

var jumpButton : bool = false

@onready var head = $Node3D
@onready var camera = $Node3D/Camera3D
@onready var holdPoint = $Node3D/Camera3D/holdPoint
@onready var rayCast = $Node3D/Camera3D/colissionRay
@onready var unsitTimer = $unsitTimer
@onready var ui = $ui
@onready var options_panel = $ui/CenterContainer/HBoxContainer/OptionsPanel
@onready var hands = $ui/CenterContainer/HBoxContainer/OptionsPanel/Hands
@onready var test = $ui/CenterContainer/HBoxContainer/OptionsPanel/test
@onready var test_2 = $ui/CenterContainer/HBoxContainer/OptionsPanel/test2
@onready var jump_button = $ui/CenterContainer/HBoxContainer/OptionsPanel/jumpButton
@onready var grind = $grind




func _ready():
	ui.visible = false

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	modSpeed = SPEED
	
	

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
		if canleave:
			sitting = false
			canleave = false
	
	if heldObject:
		heldObject.global_position = holdPoint.global_position
		if Input.is_action_pressed("ctrl") && Input.is_action_just_pressed("mwu"):
			heldObject.rotate_x(.3)
		elif Input.is_action_just_pressed("mwu"):
			heldObject.rotate_y(.3)
		if Input.is_action_pressed("ctrl") && Input.is_action_just_pressed("mwd"):
			heldObject.rotate_x(-.3)
		elif Input.is_action_just_pressed("mwd"):
			heldObject.rotate_y(-.3)
	if Input.is_action_pressed("shift"):
		modSpeed = SPEED + runSpeed
	if Input.is_action_just_released("shift"):
		modSpeed = SPEED
	hitObject = rayCast.get_collider()
	if Input.is_action_just_pressed("throw"):
		if heldObject:
			heldObject.set_sleeping(false)
			heldObject.collision_mask = 3
			heldObject.collision_layer = 3
			heldObject.set_freeze_enabled(false)
			heldObject.apply_impulse(10*(global_position.direction_to(heldObject.global_position)))
			heldObject = null
	if Input.is_action_just_pressed("interact"):
		if !GlobalController.inDialogue:
			if heldObject:
				heldObject.set_sleeping(false)
				heldObject.collision_mask = 3
				heldObject.collision_layer = 3
				heldObject.set_freeze_enabled(false)
				heldObject = null
			elif hitObject != null:
					#print(hitObject)
					if !heldObject:
						if hitObject is RigidBody3D: #.is_in_group("pickable"):
							heldObject = hitObject
							heldObject.collision_mask = 0
							heldObject.collision_layer = 0
							heldObject.set_freeze_enabled(true)
							heldObject.set_sleeping(true)
						else: pass
					elif heldObject:
						heldObject.set_sleeping(false)
						heldObject.collision_mask = 3
						heldObject.collision_layer = 3
						heldObject.set_freeze_enabled(false)
						heldObject = null
					if hitObject.is_in_group("interact"):
						hitObject.interact(self)
					if hitObject.is_in_group("sit"):
						unsitTimer.start()
						canleave = false
						sitting = true
						global_position = hitObject.get_child(0).global_position
					else:pass
			if canleave:
				canleave = false
				sitting = false
	if Input.is_action_just_pressed("esc"):
		if inMinigame:
			inMinigame = false
			camera.make_current()
			
		if !GlobalController.inDialogue:
			ui.visible=true
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if GlobalController.inDialogue:
		velocity = Vector3(0, -gravity*delta, 0)
	else:
		if is_on_floor():
			if direction:
				velocity.x = direction.x * modSpeed * (delta * 60)
				velocity.z = direction.z * modSpeed * (delta * 60)
			else:
				velocity.x = lerp(velocity.x, direction.x * modSpeed, delta * 7)
				velocity.z = lerp(velocity.z, direction.z * modSpeed, delta * 7)
		if !is_on_floor() :
			velocity.y -= gravity * delta
			velocity.x = lerp(velocity.x, direction.x * modSpeed, delta * 3)
			velocity.z = lerp(velocity.z, direction.z * modSpeed, delta * 3)
	if !jumpButton:
		velocity.x = clampf(velocity.x, -6,6)
		velocity.y = clampf(velocity.y, -6,6)
		velocity.z = clampf(velocity.z, -6,6)
		
	velocity.normalized()
	if !(sitting || inMinigame):
		move_and_slide()
		for i in get_slide_collision_count():
			var c = get_slide_collision(i)
			if c.get_collider() is RigidBody3D:
				c.get_collider().apply_central_impulse(-c.get_normal()* pushForce * velocity.length())





func _on_unsit_timer_timeout():
	canleave = true






func _on_resume_button_pressed():
	ui.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_options_button_pressed():
	options_panel.visible = !options_panel.visible


func _on_jump_button_pressed():
	jumpButton = true
	velocity.y = 300
	ui.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_hands_pressed():
	$Node3D/handsPoint.visible = true

