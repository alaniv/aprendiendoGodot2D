extends Node2D

func _input(event):
	if(event.is_action_pressed("ui_accept")):
		set_process_input(false)
		$select.playing = true
		$AnimationPlayer.stop()
		$FadeToWhite.play(1.0)
		yield($select, "finished")
		get_tree().change_scene("res://TitleScreen/FileSelectScreen/FileSelect.tscn") #TODO: arreglar el loop