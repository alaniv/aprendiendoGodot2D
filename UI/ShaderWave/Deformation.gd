extends ColorRect

signal fade_done

onready var tween = $Tween

func fade_shade_stage1():
		tween.interpolate_property(get_material(), "shader_param/depth", 0.45, 0.10, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_completed")
		emit_signal("fade_done")
	
func fade_shade_stage2():
		tween.interpolate_property(get_material(), "shader_param/depth", 0.10, 0.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_completed")
		emit_signal("fade_done")