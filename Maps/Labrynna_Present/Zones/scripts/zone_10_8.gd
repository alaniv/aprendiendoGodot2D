extends Node2D

var eoi = ["event_10_6"] # eoi = events of interest
var eoi_status = {"event_10_6": [0,0]}

func _ready():
	if eoi_status["event_10_6"] != [2,1]:
		$Event_0.queue_free() # bye bye monkeys 	;(
