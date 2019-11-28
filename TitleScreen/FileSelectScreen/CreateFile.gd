extends Control

signal create

onready var fr = [$FruitNew, $FruitSecrets, $FruitGL]
onready var cursor = get_node("../Cursor")
onready var select = get_node("../Select")

var sel = 0

func create_file_input(event):
	if event.is_action_pressed("ui_up"):
		cursor.playing = true
		fr[sel].hide()
		sel +=2
		sel %= 3
		fr[sel].show()
	elif event.is_action_pressed("ui_down"):
		cursor.playing = true
		fr[sel].hide()
		sel +=1
		sel %= 3
		fr[sel].show()
	elif event.is_action_pressed("ui_accept"):
		select.playing = true
		match sel:
			0:
				emit_signal("create")
			1:
				pass
			2:
				pass
				
func on_camera_focus():
	sel = 0
	fr[sel].show()
	
func on_camera_unfocus():
	fr[sel].hide()