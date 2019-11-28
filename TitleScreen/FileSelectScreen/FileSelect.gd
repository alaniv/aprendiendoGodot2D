extends Control

enum STATUS {PICK_FILE, CREATE_FILE, WRITE_NAME, IDLE}
var status = STATUS.PICK_FILE
var selected_file = -1

func _ready():
	$PickFile.on_camera_focus()
	$PickFile.connect("select_file", self, "select_file")
	$PickFile.connect("delete_file", self, "delete_file")
	$PickFile.connect("focus_file", $SaveFileInfo, "show_sf_info")
	$CreateFile.connect("create", self, "create_file")
	$WriteName.connect("create_ok", self, "create_ok")
	
func _input(event):
	if status == STATUS.PICK_FILE:
		$PickFile.pick_file_input(event)
	elif status == STATUS.CREATE_FILE:
		$CreateFile.create_file_input(event)
	elif status == STATUS.WRITE_NAME:
		$WriteName.write_input(event)

func select_file(num):
	if $SaveFileInfo.is_empty(num):
		selected_file = num
		status = STATUS.CREATE_FILE
		#$FadeToWhite.blink()
		$Camera2D.position.x += 160
		$PickFile.on_camera_unfocus()
		$CreateFile.on_camera_focus()
	else:
		status = STATUS.IDLE
		$FadeToWhite.play(1.0)
		yield($Select, "finished")
		get_node("/root/SaveLoader").selected_file = num # no se porque me lo parsea a string al recibirlo(?)
		get_node("/root/SaveLoader").load_next_scene()
		#get_tree().change_scene("res://Cutscenes/001/CutScene_001.tscn")
		
func create_file():
	status = STATUS.WRITE_NAME
	$Camera2D.position.x += 160
	$WriteName.clean()
	
func create_ok(plname):
	status = STATUS.PICK_FILE
	#$FadeToWhite.blink()
	$Camera2D.position.x -= 320
	if plname != "":
		$SaveFileInfo.fill(selected_file, plname)
	$CreateFile.on_camera_unfocus()
	$PickFile.on_camera_focus()
	
func delete_file(num):
	$SaveFileInfo.delete_save(num)