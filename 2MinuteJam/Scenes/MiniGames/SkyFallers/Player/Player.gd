extends CharacterBody2D

var direction 
const SPEED = 30
const MaxSpeed = 300

var canShoot : bool = true

@onready var bullet = preload("res://2MinuteJam/Scenes/MiniGames/SkyFallers/Player/Egg.tscn")
@onready var bulletPoint = $BulletPoint
@onready var shootTimer = $shootTimer

func _physics_process(delta):
	
	if Input.is_action_just_pressed("jump"):
		if canShoot:
			var b = bullet.instantiate()
			b.global_position = bulletPoint.global_position
			get_parent().add_child(b)
			shootTimer.start()
			canShoot = false
	
	direction = Input.get_axis("left", "right")
	velocity.x += direction * SPEED
	
	velocity.x = clamp(velocity.x, -MaxSpeed, MaxSpeed)
	velocity = lerp(velocity, Vector2(0,0), delta*7)
	move_and_slide()


func _on_shoot_timer_timeout():
	canShoot = true
