extends KinematicBody2D

var is_cutting = false

func cut():
	if not is_cutting:
		is_cutting = true
		$SFX_Cut.playing = false
		$SFX_Cut.playing = true
		$anim.play("leaf_falling")
		yield($SFX_Cut, "finished")
		queue_free()
		