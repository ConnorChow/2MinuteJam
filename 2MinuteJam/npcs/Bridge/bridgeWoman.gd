extends "res://2MinuteJam/npcs/_baseNPC/baseNPC.gd"


@onready var timer = $Timer

#func _ready():
	#dialogue = [["... ", "..", "hah..", ".."],["..."],["..."],["..."],["...", "Yeah..", "Thanks..."],["I'm going to go home.."]]
func _on_timer_timeout():
	dostuff()



func dostuff():
	#script the npc to move 
	velocity. z -= 5
	await get_tree().create_timer(2).timeout
	#and then 
	queue_free()

func talkedTo():
	match curline:
		5:
			timer.stop()


