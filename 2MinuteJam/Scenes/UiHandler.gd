extends Control

@onready var dialog = $PanelContainer/MarginContainer/Label
# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.

func talking(diag : String):
	set_visible(true)
	print(diag)
	dialog.set_text(diag)

func doneTalking():
	set_visible(false)
