extends Node

#clase base de events.

#Se asume siempre que son nodos hijos del Nodo EventManager, para que funcionen bien.

signal sfx_finished
signal text_read

var camera_current_position = Vector2(0,0)
var camera_next_position = Vector2(0,0)

var GameManager = null
var link = null

func _ready():
	GameManager = get_node("../../")
	link = GameManager.link
	GameManager.AudioManager.connect("sfx_finished", self, "emit_signal", ["sfx_finished"])
	GameManager.ui_readbox.connect("box_done", self, "emit_signal", ["text_read"])

func _text_down(text):
	GameManager.show_text_down(text)
	
func _text_up(text):
	GameManager.show_text_up(text)
	
func _play_song(name):
	GameManager.AudioManager.play_song(name)
	
func _stop_song():
	GameManager.AudioManager.stop_song()
	
func _play_sfx(name):
	GameManager.AudioManager.play_sfx(name)
	
func notify_event(stage): # override
	pass