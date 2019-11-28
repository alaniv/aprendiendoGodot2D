extends ColorRect

signal night_done
signal anti_night_done

onready var tween = $Tween

func night(speed):
		tween.interpolate_property(get_material(), "shader_param/trans_param", 1.0, 0.0, speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_completed")
		emit_signal("night_done")
		
func anti_night(speed):
		tween.interpolate_property(get_material(), "shader_param/trans_param", 0.0, 1.0, speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_completed")
		emit_signal("anti_night_done")
	