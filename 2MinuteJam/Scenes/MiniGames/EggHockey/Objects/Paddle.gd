extends RigidBody2D

var playerGoals :int
var enemyGoals : int

@onready var eggBall = preload("res://2MinuteJam/Scenes/MiniGames/EggHockey/Objects/EggBall.tscn")

@export var speed = 500

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

func _physics_process(delta):
	var direction = Input.get_axis("forward", "back")
	
	if direction != 0:
		linear_velocity = Vector2(0, speed * direction)
	else:
		linear_velocity = Vector2.ZERO

func updateScore():
	var b = eggBall.instantiate()
	$"../CanvasLayer/Control/PlayerGoal".set_text(str(playerGoals))
	$"../CanvasLayer/Control/EnemyGoal".set_text(str(enemyGoals))
	get_parent().call_deferred("add_child",b)
	b.global_position = $"../EggPoint".global_position
	

func _on_left_goal_body_entered(body):
	#print("hit")
	body.queue_free()
	enemyGoals +=1
	updateScore()



func _on_right_goal_body_entered(body):
	print("hit")
	playerGoals +=1
	updateScore()

