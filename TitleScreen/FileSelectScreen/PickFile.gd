extends Control

var sel = Vector2(0,1)
var del_sel = -1
onready var fr = [[$FruitCopy, $Fruit1, $Fruit2, $Fruit3],[$FruitErase]]
signal focus_file(num)
signal select_file(num)
signal delete_file(num)

enum STATUS {PICK, DELETE_PICK, DELETE_CONFIRM}
var status = PICK

onready var cursor = get_node("../Cursor")
onready var select = get_node("../Select")

func pick_file_input(event):
	if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
		if status == STATUS.DELETE_PICK:
			return #no cambia
		if sel.y == 0:
			cursor.playing = true
			fr[sel.x][sel.y].hide()
			sel.x = int(sel.x +1) % 2
			fr[sel.x][sel.y].show()
	elif event.is_action_pressed("ui_up"):
		if status == STATUS.DELETE_CONFIRM:
			return
		if sel.x == 0:
			cursor.playing = true
			fr[sel.x][sel.y].hide()
			sel.y = int(sel.y +3 )% 4
			fr[sel.x][sel.y].show()
			emit_signal("focus_file", sel.y-1)
	elif event.is_action_pressed("ui_down"):
		if status == STATUS.DELETE_CONFIRM:
			return
		if sel.x == 0:
			cursor.playing = true
			fr[sel.x][sel.y].hide()
			sel.y = int(sel.y +1) % 4
			fr[sel.x][sel.y].show()
			emit_signal("focus_file", sel.y -1)
	elif event.is_action_pressed("ui_accept"):
		select.playing = true
		match sel:
			Vector2(0,0):
				if status == STATUS.PICK:
					pass # TODO COPY
				elif status == STATUS.DELETE_PICK or status == STATUS.DELETE_CONFIRM:
					delete_mode_cancel()
			Vector2(0,1), Vector2(0,2), Vector2(0,3):
				if status == STATUS.PICK:
					emit_signal("select_file", int(sel.y -1)) # float...
				elif status == STATUS.DELETE_PICK:
					del_sel = int(sel.y -1)
					delete_mode_confirm()
			Vector2(1,0):
				if status == STATUS.PICK:
					delete_mode()
				elif status == STATUS.DELETE_CONFIRM:
					emit_signal("delete_file", del_sel)
					print("delete " + str(del_sel))
					delete_mode_cancel()
			_:
				print(sel) #error

func on_camera_focus():
	sel = Vector2(0,1)
	fr[sel.x][sel.y].show()
	
func on_camera_unfocus():
	fr[sel.x][sel.y].hide()
	
func delete_mode():
	status = STATUS.DELETE_PICK
	fr[1][0].hide()
	sel = Vector2(0,0)
	fr[0][0].show()
	$BackgroundDel.show()
	pass
	
func delete_mode_cancel():
	status = STATUS.PICK
	$BackgroundDel.hide()
	fr[0][0].hide()
	fr[1][0].hide()
	fr[0][1].hide()
	fr[0][2].hide()
	fr[0][3].hide()
	on_camera_focus()
	$"../SaveFileInfo".show_sf_info(0)
	
func delete_mode_confirm():
	status = STATUS.DELETE_CONFIRM
	sel = Vector2(0,0)
	fr[sel.x][sel.y].show()
	
	
	