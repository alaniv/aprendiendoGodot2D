extends Node2D

signal enter_level(name, vector)
signal enter_scene(vector)

var checkpoint_pos = null
var global_checkpoint_pos = Vector2(80,120)
var global_checkpoint_zone = Vector2(10,5)
var world_area = "Labrynna_Present" # por ahora el unico. Despues completo
var zone = Vector2(10,5)
onready var teleport_node = null
onready var eventManager = $"../EventManager"

func init_map():
	var new_zone = load("res://Maps/" + world_area + "/Zones/zone_" + str(zone.x) + "_" + str(zone.y) + ".tscn").instance()
	add_child(new_zone)
	teleport_node = new_zone.get_node("Teleport")
	connect_zone_to_evm(new_zone)
	#TODO: agregar un point2D para el spawn. Cosa de que no quede en cualquier lado link...
	$"..".link.position = global_checkpoint_pos
	
func update_current_zone(direction):
	# intepretar direction, modificar indices.
	zone += direction
	var old_zone = get_children()[0]
	var new_zone = load("res://Maps/" + world_area + "/Zones/zone_" + str(zone.x) + "_" + str(zone.y) + ".tscn").instance()
	new_zone.position.x = old_zone.position.x + world_area_map_size().x * direction.x
	new_zone.position.y = old_zone.position.y - (world_area_map_size().y - 16) * direction.y
	connect_zone_to_evm(new_zone)
	add_child(new_zone)
	teleport_node.disconnect("go_to", $"..", "teleport")
	teleport_node = new_zone.get_node("Teleport") #update reference
	teleport_node.connect("go_to", $"..", "teleport")
	yield($"..", "queue_free_map")
	old_zone.queue_free()
	# return old_zone # return para borrar cuando GM lo considere necesario(transiciones...)
	
func update_area(area, new_zone_vec,spawn):
	zone = new_zone_vec
	world_area = area
	var old_zone = get_children()[0]
	var new_zone = load("res://Maps/" + world_area + "/Zones/zone_" + str(zone.x) + "_" + str(zone.y) + ".tscn").instance()
	connect_zone_to_evm(new_zone)
	add_child(new_zone)
	teleport_node = get_child(1).get_node("Teleport") #update reference
	teleport_node.connect("go_to", $"..", "teleport")
	var pos_spawn = get_child(1).get_node("Spawn_" + str(spawn)).position
	old_zone.queue_free()
	return pos_spawn # return para borrar cuando GM lo considere necesario(transiciones...)
	
func connect_zone_to_evm(new_zone):
	var new_zone_script = new_zone.get_script()
	if new_zone_script:
		if new_zone_script.has_script_signal("event_triggered") :
			new_zone.connect("event_triggered", eventManager, "handle_ev_trigger")
		if new_zone_script.has_script_signal("area_teleport"):
			new_zone.connect("area_teleport", $"..", "area_teleport")
		if "eoi" in new_zone:
			new_zone.eoi_status = eventManager.get_status(new_zone.eoi)
			#print(new_zone.eoi_status)
			
func world_area_map_size():
	if world_area == "Labrynna_Present/MakuPath":
		return Vector2(240,192)
	else:
		return Vector2(160,144)
# metodo de acceso para el AUTOLOAD de guardado:
func get_data():
	var dic_mp = {}
	dic_mp["zone"] = [global_checkpoint_zone.x, global_checkpoint_zone.y]
	dic_mp["pos"] = [global_checkpoint_pos.x, global_checkpoint_pos.y]
	dic_mp["world_area"] = world_area
	return dic_mp
	
func set_data(data):
	if data.has("pos"):
		checkpoint_pos = Vector2(data["pos"][0], data["pos"][1])
		global_checkpoint_pos = checkpoint_pos
	if data.has("zone"):
		zone = Vector2(data["zone"][0], data["zone"][1])
		global_checkpoint_zone = zone
	if data.has("world_area"):
		world_area = data["world_area"]