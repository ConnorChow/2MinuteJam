extends CharacterBody3D

@export var speed : float  = 20
@export var maxSpeed : float = 200
@export var health : float = 200
@export var damage : float = 5
@export var attackSpeed : float = 4


@onready var navAgent = $NavigationAgent3D




var isDying : bool = false
var player
var direction : Vector3

func _physics_process(delta):
	if player != null:
		navAgent.target_position = player.global_position
		direction = to_local(navAgent.get_next_path_position()).normalized()
		velocity += direction * speed
		
	velocity.x = clamp(velocity.x, -maxSpeed, maxSpeed)
	velocity.z = clamp(velocity.z, -maxSpeed, maxSpeed)
	move_and_slide()


func _on_player_detector_area_entered(area):
	player = area.get_parent()

