extends MeshInstance3D

@export var useSystemTime : bool = false

@onready var label = $Label3D
@onready var timer = $Label3D/Timer

var time : String
# Called when the node enters the scene tree for the first time.
func _ready():
	if useSystemTime:
		time = Time.get_time_string_from_system()
		label.set_text(time)
		timer.start()




func _on_timer_timeout():
	time = Time.get_time_string_from_system()
	label.set_text(time)
	timer.start()

