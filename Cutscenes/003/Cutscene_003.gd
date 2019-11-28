extends Node2D

signal done

func _ready():
	$Timer.connect("timeout", self, "do")
	$Timer.start()
	do()

func do():
	$close.playing = true
	$FadeToWhite.play_reverse(1.5)
	yield($FadeToWhite/AnimationPlayer, "animation_finished")
	$close.playing = true
	$FadeToWhite.play(2.0)
	yield($FadeToWhite/AnimationPlayer, "animation_finished")
	yield(self, "done")
	$"../..".tree_resume()
	queue_free()
	
func _input(event):
	if(event.is_action_pressed("ui_accept")):
		emit_signal("done")