extends Node2D

const STATUS = {"NOTREADY":0, "READY":1, "ACTIVE":2, "DONE":3}

# los flags irian en un save...
"""
var event_flags = {
	# event_name : [status, stage, event_object_reference ]
	"event_10_5" : {"status": STATUS.READY, "stage": 0, "ref": "res://Event/Event_10_5.tscn", "ref2": null},
	"event_10_6" : {"status": STATUS.READY, "stage": 0, "ref": "res://Event/Event_10_6.tscn", "ref2": null},
	"event_NayruSong" : {"status": STATUS.READY, "stage": 0, "ref": "res://Event/Event_NayruSong.tscn", "ref2": null },
	"event_Veran_Appears" : {"status": STATUS.READY, "stage": 0, "ref": "res://Event/Event_VeranAppears.tscn", "ref2": null}
}
"""
var event_flags = {
	# event_name : [status, stage, event_object_reference ]
	"event_10_5" : {"status": STATUS.READY, "stage": 0, "ref": "res://Event/Event_10_5.tscn", "ref2": null},
	"event_10_6" : {"status": STATUS.READY, "stage": 0, "ref": "res://Event/Event_10_6.tscn", "ref2": null},
	"event_Veran_Appears" : {"status": STATUS.READY, "stage": 0, "ref": "res://Event/Event_VeranAppears.tscn", "ref2": null}
}

onready var GameManager = get_node("../")

#POR AHORA DEV. DEBERIA SER PARA HABILITAR EL ITEM.
# LO CORRECTO SERIA QUE LEVANTE DEL SIST DE GUARDADO...
func init_evm():
	if event_flags["event_Veran_Appears"]["status"] == STATUS.DONE:
		GameManager.AudioManager.play_song("Overworld")


func handle_ev_trigger(id, dir, terminate=false): # Eventos que inician pre teleport
	if terminate:
		event_flags[id]["status"] = STATUS.DONE
		notify(id)
		update_event(id)
		event_flags[id]["ref2"] = null
	elif event_flags[id]["status"] == STATUS.READY:
		init_event(id, dir)
		event_flags[id]["status"] = STATUS.ACTIVE
		notify(id)
		update_event(id)
	elif event_flags[id]["status"] == STATUS.ACTIVE:
		notify(id)
		update_event(id)
		
func update_event(id):
	if event_flags[id]["status"] == STATUS.ACTIVE:
		event_flags[id]["stage"] += 1
	elif event_flags[id]["status"] == STATUS.DONE:
		event_flags[id]["stage"] += 1 #?

func init_event(id, dir): #dir es un offset de la creacion(lo creo en la esc siguiente por ej...)
	var ev_name = event_flags[id]["ref"]
	var ev = load(ev_name).instance()
	ev.camera_current_position = GameManager.cam_position()
	ev.camera_next_position = GameManager.cam_position() + Vector2(160 * dir.x, -128 * dir.y)
	add_child(ev)
	event_flags[id]["ref2"] = ev #guardar una referencia(?)
	
func get_status(arr_eoi):
	var dic = {}
	for event in arr_eoi:
		var ef = event_flags[event]
		dic[event] = [ef["status"], ef["stage"]]
	return dic
	
func notify(id):
	var event = event_flags[id]["ref2"]
	if event != null: # es para debug mas que nada...
		event_flags[id]["ref2"].notify_event(event_flags[id]["stage"])
		
# metodo de acceso para el AUTOLOAD de guardado:
func get_data():
	var dic_ef = {}
	for key in event_flags:
		dic_ef[key] = {"status": event_flags[key]["status"]}
	return dic_ef
	
func set_data(data):
	for key in event_flags:
		event_flags[key]["status"] = data[key]["status"]