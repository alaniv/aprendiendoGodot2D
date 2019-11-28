extends Node2D

signal event_triggered(event_id, offset)

var eoi = ["event_10_6"] # eoi = events of interest
var eoi_status = {"event_10_6": [0,0]}

func _process(delta):
	if eoi_status["event_10_6"] == [2,1]:
		$Objects/TriforceBlock.make_pushable()
		$Objects/TriforceBlock.connect("pushed_triforce_block", self, "update_event")
		$EventTriggers/ForcePush.connect("body_entered", self, "trigger_event")
		$EventTriggers/ChangeSong.connect("body_entered", self, "change_song")
		$EventTriggers/Barrier/CollisionShape2D.disabled = true
		$EventTriggers/Barrier2/CollisionShape2D.disabled = true
	else:
		$EventTriggers.queue_free()
	set_process(false)
	
func update_event():
	emit_signal("event_triggered", "event_10_6", Vector2(0,0)) 
	$EventTriggers/ForcePush.queue_free()
	$EventTriggers/Barrier.queue_free()
	$EventTriggers/Barrier2.queue_free()
	
func trigger_event(body):
	emit_signal("event_triggered", "event_10_6", Vector2(0,0)) 
	$EventTriggers/ForcePush.disconnect("body_entered", self, "trigger_event")
	$EventTriggers/Barrier.connect("barrier_triggered",self, "alert")
	$EventTriggers/Barrier2.connect("barrier_triggered",self, "alert")
	$EventTriggers/Barrier/CollisionShape2D.disabled = false
	$EventTriggers/Barrier2/CollisionShape2D.disabled = false
	
func alert(): # TODO
	$"../../".show_text_down("Where are you going!?!\nHurry up and move this!") # despues upgradear esto
	
func change_song(body):
	print("chagnge song")
	emit_signal("event_triggered", "event_10_6", Vector2(0,0)) 
	$EventTriggers/ChangeSong.queue_free()