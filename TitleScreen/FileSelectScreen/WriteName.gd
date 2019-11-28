extends Control

signal create_ok
onready var player_name = [$Name/l0, $Name/l1, $Name/l2, $Name/l3, $Name/l4]
var char_index = 0
onready var input_cursor_1 = $Cursor
onready var input_cursor_2 = $Cursor2
onready var input_cursor_3 = $Cursor3
const POS1 = Vector2(24,45)
const POS2 = Vector2(88,45)
const POSv2 = [Vector2(26,136), Vector2(48,136), Vector2(120,136)]
var cur_pos = Vector2(0,0)
var cur_pos_2 = -1

func clean():
	for label in player_name:
		label.text = " "
	char_index = 0
	cur_pos = Vector2(0,0)
	cur_pos_2 = -1
	input_cursor_1.rect_position = POS1
	input_cursor_2.rect_position = POSv2[0]
	input_cursor_3.rect_position = Vector2(81,24)
	input_cursor_1.show()
	input_cursor_2.hide()

func write_input(event):
	var dir = Vector2(0,0)
	if event.is_action_pressed("ui_accept"):
		if cur_pos_2 == 2:
			emit_signal("create_ok", get_name(player_name).strip_edges(true,false))
		elif cur_pos_2 == 1:
			char_index = fposmod(char_index + 1, 5)
		elif cur_pos_2 == 0:
			char_index = fposmod(char_index - 1, 5)
		elif cur_pos_2 == -1:
			player_name[char_index].text = get_char(int(cur_pos.x), int(cur_pos.y))
			char_index = clamp(char_index + 1, 0, 4)
		input_cursor_3.rect_position = Vector2(81,24) + Vector2(char_index*8,0)
		return
		
	elif event.is_action_pressed("ui_left"):
		dir = Vector2(-1,0)
	elif event.is_action_pressed("ui_right"):
		dir = Vector2(1,0)
	elif event.is_action_pressed("ui_up"):
		dir = Vector2(0,-1)
	elif event.is_action_pressed("ui_down"):
		dir = Vector2(0,1)
	if cur_pos.y == 5 and dir.y != 0:
		cur_pos.x = cur_pos_2*3
		cur_pos.y = 0 if dir.y == 1 else 4
		input_cursor_1.show()
		input_cursor_2.hide()
		cur_pos_2 = -1
	else:
		cur_pos += dir
		cur_pos.x = fposmod(int(cur_pos.x),12)
	if cur_pos.x in range(0,6) and cur_pos.y in range(0,5):
		input_cursor_1.rect_position = POS1 + Vector2(cur_pos.x*8, cur_pos.y*16)
	elif cur_pos.x in range(6,12) and cur_pos.y in range(0,5):
		input_cursor_1.rect_position = POS2 + Vector2(cur_pos.x*8 - 48, cur_pos.y*16)
	elif cur_pos.y in [-1,5] and dir.y!= 0:
		cur_pos.y = 5
		input_cursor_1.hide()
		input_cursor_2.show()
		cur_pos_2 = clamp(int(cur_pos.x)/3, 0, 2)
		input_cursor_2.rect_position = POSv2[cur_pos_2]
	else:
		cur_pos_2 = fposmod(cur_pos_2 + int(dir.x) ,3) 
		input_cursor_2.rect_position = POSv2[cur_pos_2]
	
func get_name(list_labels):
	var _name = ""
	for i in range(0, list_labels.size()):
		_name += list_labels[i].text
	return _name 

const char_matrix = [
	['A','B','C','D','E','F',   'a','b','c','d','e','f'],
	['G','H','I','J','K','L',   'g','h','i','j','k','l'],
	['M','N','O','P','Q','R',   'm','n','o','p','q','r'],
	['S','T','U','V','W','X',   's','t','u','v','w','x'],
	['Y','Z',' ',' ',' ',' ',   'y','z',' ',' ',' ',' '],	
]

func get_char(x,y):
	return char_matrix[y][x]