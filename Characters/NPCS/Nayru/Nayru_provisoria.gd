extends KinematicBody2D
var note = load("res://Characters/NPCS/Nayru/note.tscn")

var s_left = 1
var s_right = 1

func sing_left():
	var notes = note.instance()
	add_child(notes)
	notes.get_node("anim").play("Left" + str(s_left), -1, 0.5)
	s_left = randi() % 3 + 1
	
func sing_right():
	var notes = note.instance()
	add_child(notes)
	notes.get_node("anim").play("Right" + str(s_right), -1, 0.5)
	s_right = randi() % 3 + 1

