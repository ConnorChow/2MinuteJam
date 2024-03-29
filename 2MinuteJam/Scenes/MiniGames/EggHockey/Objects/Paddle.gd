extends RigidBody2D

var playerGoals :int
var enemyGoals : int

@onready var eggBall = preload("res://2MinuteJam/Scenes/MiniGames/EggHockey/Objects/EggBall.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass



func updateScore():
	var b = eggBall.instantiate()
	$"../Control/PlayerGoal".set_text(str(playerGoals))
	$"../Control/EnemyGoal".set_text(str(enemyGoals))
	get_parent().call_deferred("add_child",b)
	b.global_position = $"../EggPoint".global_position
	


func _on_left_goal_body_entered(body):
	body.queue_free()
	enemyGoals +=1
	updateScore()



func _on_right_goal_body_entered(body):
	playerGoals +=1
	updateScore()

