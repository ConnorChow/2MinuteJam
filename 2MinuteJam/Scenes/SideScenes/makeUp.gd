extends Sprite2D

var clickPosRed : Array = []
var clickPosGreen : Array = []
var clickPosBlack : Array = []
var clickPosHotPink : Array = []
var clickPosPeach : Array = []
var clickPosChocolate : Array = []
var clickPosSalmon : Array = []
var clickPosWheat : Array = []


var paintIndex : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
func _process(_delta):
	if Input.is_action_pressed("throw"):
		match paintIndex:
			0:
				clickPosRed.append(get_local_mouse_position ( ))
			1:
				clickPosGreen.append(get_local_mouse_position ( ))
			2:
				clickPosBlack.append(get_local_mouse_position ( ))
			3:
				clickPosHotPink.append(get_local_mouse_position ( ))
			4:
				clickPosPeach.append(get_local_mouse_position ( ))
			5:
				clickPosChocolate.append(get_local_mouse_position ( ))
			6:
				clickPosSalmon.append(get_local_mouse_position ( ))
			7:
				clickPosWheat.append(get_local_mouse_position ( ))

				
				
		queue_redraw()


func _draw():

	for point in clickPosRed:
		draw_circle(point, 10, Color.RED)
	for point in clickPosGreen:
		draw_circle(point, 10, Color.GREEN)
	for point in clickPosBlack:
		draw_circle(point, 10, Color.BLACK)
	for point in clickPosHotPink:
		draw_circle(point, 10, Color.HOT_PINK)
	for point in clickPosPeach:
		draw_circle(point, 10, Color.PERU)
	for point in clickPosChocolate:
		draw_circle(point, 10, Color.CHOCOLATE)
	for point in clickPosSalmon:
		draw_circle(point, 10, Color.SALMON)
	for point in clickPosWheat:
		draw_circle(point, 10, Color.WHEAT)
		
		



func _on_red_button_pressed():
	paintIndex =0

func _on_green_button_pressed():
	paintIndex =1


func _on_black_button_pressed():
	paintIndex =2




func _on_hot_pink_button_pressed():
	paintIndex =3


func _on_peru_button_pressed():
	paintIndex =4


func _on_chocolate_button_pressed():
	paintIndex =5


func _on_salmon_button_pressed():
	paintIndex =6


func _on_wheat_button_pressed():
	paintIndex =7



