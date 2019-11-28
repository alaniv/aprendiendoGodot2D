extends CanvasLayer

signal effect_done

onready var timer = $timer
var xar = 0.55

func _ready():
	$ColorRect.get_material().set_shader_param("xar", xar)
	timer.connect("timeout", self, "open_door")
	
func activate_effect():
	timer.start()
	
func open_door():
	if xar > 0.0:
		xar -= 0.05
		$ColorRect.get_material().set_shader_param("xar", xar)
	elif xar <= 0.0:
		timer.stop()
		emit_signal("effect_done")
		print("effect_done")
