extends Control

var diagToHandle = []
var curText : int = 0
@onready var dialog = $PanelContainer/MarginContainer/Label
# Called when the node enters the scene tree for the first time.




func talking(diag : Array ):
	set_visible(true)
	print(diag)
	curText = 0
	diagToHandle = diag
	dialog.set_text(diagToHandle[curText])



func _process(_delta):
	if visible == true:
		if Input.is_action_just_pressed("interact"):
			if curText <= diagToHandle.size():
				dialog.set_text(diagToHandle[curText])
				curText +=1
				
				if curText == diagToHandle.size() :
					print("this one")
					doneTalking()
			else:
				doneTalking()
				print("that one")

func doneTalking():
	set_visible(false)
	GlobalController.inDialogue = false
	print("done talking")
