extends "res://2MinuteJam/npcs/_baseNPC/baseNPC.gd"

var curLines : int = 1

var dialogue2 = ["..."]
var dialogue3 = ["..."]
var dialogue4 = ["..."]
var dialogue5 = ["..."]
var dialogue6 = ["...", "Yeah..", "Thanks..."]
var dialogue7 = ["I'm going to go home.."]

@onready var timer = $Timer

func _on_timer_timeout():
	dostuff()

func _physics_process(delta):
	
	if !is_on_floor():
		velocity.y -= gravity * delta
		velocity.z = lerpf(velocity.z, 0 , delta * 3)
	
	move_and_slide()

func dostuff():
	#script the npc to move 
	velocity. z -= 5
	await get_tree().create_timer(2).timeout
	#and then 
	queue_free()

func talkedTo():
	match curLines:
		1:
			dialogue = dialogue2
		2:
			dialogue = dialogue3
		3:
			dialogue = dialogue4
		4:
			dialogue = dialogue5
		5:
			dialogue = dialogue6
			timer.stop()
		_: dialogue = dialogue7
	curLines +=1

