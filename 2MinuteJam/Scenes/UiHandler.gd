extends Control

var diagToHandle = []
var curText : int = 0
@onready var dialog = $PanelContainer/MarginContainer/Label

@onready var name_plate = $PanelContainer/MarginContainer2/namePlate
@onready var worst_person = %worstPerson
@onready var buffer = $buffer

var npcName
var bufferTime : bool = false

func talking(diag : Array , myName :String):
	if !bufferTime:
		set_visible(true)
		GlobalController.inDialogue = true
		#print(diag)
		curText = 0
		npcName = myName
		diagToHandle = diag
		dialog.set_text(diagToHandle[curText])
		name_plate.set_text(npcName)



func _process(_delta):
	if visible == true:
		if Input.is_action_just_pressed("interact"):
			if curText <= diagToHandle.size()-1:
				dialog.set_text(diagToHandle[curText])
				curText +=1
				if npcName == "Max":
					if curText ==4:
						await get_tree().create_timer(.4).timeout
						worst_person.play()
				
				#if curText == diagToHandle.size() :
					#print("this one")
					#doneTalking()
			else:
				doneTalking()
				#print("that one")

func doneTalking():
	buffer.start()
	bufferTime = true
	set_visible(false)
	GlobalController.inDialogue = false
	#print("done talking")


func _on_buffer_timeout():
	bufferTime = false
	pass # Replace with function body.
