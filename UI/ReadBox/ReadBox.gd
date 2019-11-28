extends Control

signal box_done
signal box_accept

onready var timer = $TypingTimer
onready var box_up = $Up
onready var box_down = $Down
var box_busy = false

const MAX_SIZE_LINE = 16

func _ready():
	box_up.hide()
	box_down.hide()
	timer.set_wait_time(.06) # time between letters
	
#func _process(delta):
#	test()
#	set_process(false)
	
func test():
	write_dialogue_up("You're not Santa! You don't.")
	
func _input(event):
	if not box_busy:
		return
	if(event.is_action_pressed("ui_accept")):
		emit_signal("box_accept")

func write_dialogue_up(string):
	_write_dialogue(string, box_up)

func write_dialogue_down(string):
	_write_dialogue(string, box_down)
		
func _write_dialogue(string, box_node):
	if not box_busy:
		box_busy = true
		box_node.show()
		###
		var strings = string.split("\n")
		for i in range(0, strings.size()):
			var line_overflow = false
			var line_count = 0
			var line = strings[i]
			var words = line.split(" ")
			for j in range(0, words.size()):
				var word = words[j]
				if line_count != 0:
					box_node.get_node("text").add_text(" ")
				line_count += word.length()
				if "." in word: line_count -= 1 #probando...
				if line_count > MAX_SIZE_LINE:
					box_node.get_node("text").add_text("\n")
					line_count = word.length()
				for letter in word:
					if letter == ".": timer.set_wait_time(.2)
					timer.start()
					box_node.get_node("text").add_text( letter )
					$Letter.playing = true
					yield(timer, "timeout")
					if letter == ".": timer.set_wait_time(.06)
				if line_count + 1 > MAX_SIZE_LINE and j != (words.size()-1):
					line_count = 0 # si entra un espacio al final, lo ponemos 
								   # (de ultima sobra al final), si no saltamos.
					box_node.get_node("text").add_text("\n")
				else:
					 line_count += 1
			yield(self,"box_accept")
			$Page.playing = true
			if i != (strings.size()-1):
				box_node.get_node("text").add_text("\n")
		###
		box_busy = false
		box_node.get_node("text").clear()
		box_node.hide()
		emit_signal("box_done")
		
		
