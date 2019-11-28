extends Node2D

onready var fruits = [$Fruit1, $Fruit2, $Fruit3]
onready var cursor = $Cursor
onready var select = $Select
onready var Song = $Song
var sel = 0

func _ready():
	fruits[0].visible = true
	fruits[1].visible = false
	fruits[2].visible = false
	Song.playing = true
	$Blink.connect("timeout", self, "oscilate_cursor")

func _input(event):
	if event.is_action_pressed("ui_up"):
		cursor.playing = true
		fruits[sel].hide()
		sel +=2
		sel %= 3
		fruits[sel].show()
	elif event.is_action_pressed("ui_down"):
		cursor.playing = true
		fruits[sel].hide()
		sel +=1
		sel %= 3
		fruits[sel].show()
	elif event.is_action_pressed("ui_accept"):
		select.playing = true
		set_process_input(false)
		$Blink.start()
		match sel:
			0:
				yield(select, "finished")
				get_tree().change_scene("res://Test/Test.tscn") # esto deberìa alcanzar...
			1:
				get_node("/root/SaveLoader").save_current_file()
				yield(select, "finished")
				get_tree().change_scene("res://Test/Test.tscn")
				pass # guarda al disco los saves, y vuelve al maingame
			2:
				get_node("/root/SaveLoader").save_current_file()
				yield(select, "finished")
				get_tree().change_scene("res://TitleScreen/PressStartScreen/PressStartScreen.tscn")
				
func oscilate_cursor():
	fruits[sel].visible = not fruits[sel].visible
	