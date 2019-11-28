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
	var sprite = $Sprite
	$Tween.interpolate_property(sprite, "position",
        Vector2(0,0), Vector2(-40,0), 5.0,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	$close.playing = false
	yield(self, "done")
	$close.playing = true
	$FadeToWhite.play(2.0)
	yield($FadeToWhite/AnimationPlayer, "animation_finished")
	$"../..".tree_resume()
	queue_free()
	
func _input(event):
	if(event.is_action_pressed("ui_accept")):
		emit_signal("done")