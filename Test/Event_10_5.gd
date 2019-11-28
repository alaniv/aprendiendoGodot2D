extends "res://Event/Event.gd"

func _process(delta):
	set_process(false)
	self.visible = true
	link.pause()
	link.position = Vector2(72,0)
	_play_sfx("BeginQuest")
	link.play_anim("Jump_Down")
	$Deformation.fade_shade_stage1()
	yield($Deformation, "fade_done")
	link.tween_position(Vector2(0,72), 1.0, Tween.TRANS_QUAD)
	$Deformation.fade_shade_stage2()
	yield($Deformation, "fade_done")
	link.unpause()
	#link.get_node("animator").play("Idle_Down")
	link.set_status_idle()
	self.queue_free()
