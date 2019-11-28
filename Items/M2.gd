extends Sprite
var brackets
var current_index
func _ready():
	set_process_input(false)
	brackets = $Brackets.get_children() # In order of tree hierarchy == numeric order
	current_index = 0
	
func _process(delta):
	for node in brackets:
		node.hide()
	brackets[current_index].show()
	set_process(false)
	
func _input(event):
	if event.is_action_pressed("ui_left"):
		current_index -= 1
		set_process(true)
	elif event.is_action_pressed("ui_right"):
		current_index += 1
		set_process(true)
	elif event.is_action_pressed("ui_up"):
		current_index -= 5
		set_process(true)
	elif event.is_action_pressed("ui_down"):
		current_index += 5
		set_process(true)
	if current_index < 0:
		current_index += 15
	if current_index > 14:
		current_index -= 15
		