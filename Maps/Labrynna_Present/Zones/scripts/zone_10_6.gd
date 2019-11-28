extends Node2D

signal event_triggered(event_id, offset)

var eoi = ["event_10_6"] # eoi = events of interest
var eoi_status = {"event_10_6": [0,0]}

func _process(delta):
	set_process(false)
	if eoi_status["event_10_6"][0] == 1 and eoi_status["event_10_6"][1] == 0:
		$EventTriggers/ev1.connect("body_entered", self, "_on_body_enter", ["event_10_6", Vector2(0,1)])
	
func _on_body_enter(body, id, offset):
	if body.is_in_group("Player"):
		emit_signal("event_triggered", id, offset) 
