extends Node2D

signal event_triggered(event_id, offset)

var eoi = ["event_10_5"] # eoi = events of interest
var eoi_status = {"event_10_5": [0,0]}

func _process(delta):
	set_process(false)
	if eoi_status["event_10_5"][0] == 1 and eoi_status["event_10_5"][1] == 0:
		emit_signal("event_triggered", "event_10_5", Vector2(0,0))
