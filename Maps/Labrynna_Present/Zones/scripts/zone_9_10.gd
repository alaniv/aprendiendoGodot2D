extends Node2D

signal event_triggered

onready var GameManager = $"../../"

var eoi = ["event_10_6"] # eoi = events of interest
var eoi_status = {"event_10_6": [0,0]}

func _ready():
	if eoi_status["event_10_6"] == [2,4]:
		$Event_0/Area2D.connect("body_entered", self, "en_progreso", [1])
		$Event_0/Nayru/anim.play("Singing")
	else:
		$Event_0.queue_free()
		$Objects/Portal.visible = true

func en_progreso(body, id):
	if id == 1:
		$Event_0/Area2D.disconnect("body_entered", self, "en_progreso")
		GameManager.show_text_down("Isn't beautiful?")
		yield(GameManager.get_node("UI/ReadBox"), "box_done")
		emit_signal("event_triggered", "event_10_6", Vector2(0,0), [true]) # terminacion...
		GameManager.tree_await()
		var cs = load("res://Cutscenes/002/Cutscene_002.tscn").instance()
		GameManager.get_node("CutScenePlaceHolder").add_child(cs)
		$Event_0.queue_free() # aca dejo libre la escena para el event.
		emit_signal("event_triggered", "event_Veran_Appears", Vector2(0,0)) 
		yield(cs, "done")
		
func show_portal_active():
	$Objects/Portal.visible = true
