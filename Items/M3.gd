extends Sprite

var brackets
var current_section
var current_index
var current_index_mem = [0,0] # index is stored on panel change

func _ready():
	set_process_input(false)
	var brackets_e = $BracketsEscences.get_children() # In order of tree hierarchy == numeric order
	var brackets_o = $BracketsOptions.get_children() # In order of tree hierarchy == numeric order
	brackets = [brackets_e, brackets_o]
	current_index = 0
	current_section = 0
	
	
func _process(delta):
	for section in brackets:
		for node in section:
			node.hide()
	brackets[current_section][current_index].show()
	set_process(false)
	
func _input(event):
	if event.is_action_pressed("ui_left"):
		current_index_mem[current_section] = current_index
		current_section = 1 if current_section == 0 else 0
		current_index = current_index_mem[current_section]
		set_process(true)
	elif event.is_action_pressed("ui_right"):
		current_index_mem[current_section] = current_index
		current_section = 1 if current_section == 0 else 0
		current_index = current_index_mem[current_section]
		set_process(true)
	elif event.is_action_pressed("ui_up"):
		current_index -= 1
		set_process(true)
	elif event.is_action_pressed("ui_down"):
		current_index += 1
		set_process(true)
	if current_index < 0 and current_section == 0:
		current_index += 8 
	elif current_index < 0 and current_section == 1:
		current_index += 3
	if current_index > 7 and current_section == 0:
		current_index -= 8 
	elif current_index > 2 and current_section == 1:
		current_index -= 3
	elif event.is_action_pressed("Action_B"):
		# ACA ABRO EL MENU DE SAVE LOAD... EN REALIDAD NO SIRVE ASI PORQUE DEBE TENER UN COMPORTAMIENTO UN TOQUE DISTINTO AL DE SCREEN DE MUERTE... PERO ME SIRVE POR AHORA.
		# TODO: implementar la verdadera pantalla de menu->save. No es un cambio de scene...
		get_tree().paused = false
		get_node("/root/SaveLoader").update_current_file() # updateo el temporal.
		get_tree().change_scene("res://TitleScreen/ContinueScreen/ContinueScreen.tscn") #aca deciden si guardar
		
func attempting_save():
	return current_section == 1 and current_index == 2