extends KinematicBody2D

signal pushed_triforce_block #para freezar a link, y mover a possesed impa.

var can_push = false
var is_pushed = false

func make_pushable():
	position = Vector2(56,56)
	$Area2D.connect("body_entered", self, "_allow_push", [true])
	$Area2D.connect("body_exited", self, "_allow_push", [false])

func try_push_block():
	if not is_pushed and can_push:
		is_pushed = true
		#print("ok")
		$Tween.interpolate_property(self, "position", position, position - Vector2(16,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		yield($Tween, "tween_completed")
		emit_signal("pushed_triforce_block")
		
func _allow_push(body, param):
	if body.is_in_group("Player"):
		can_push = param
