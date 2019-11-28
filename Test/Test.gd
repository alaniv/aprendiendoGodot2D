extends Node2D

signal teleport_start(direction)
signal teleport_done(direction)

var allow_input = true
onready var ui_status = $UI/StatusBar
onready var ui_readbox = $UI/ReadBox
onready var camera = $camera
onready var link = $Link
onready var input_cd = $InputCD
onready var AudioManager = $AudioManager
onready var Inventory = $Inventory

func _ready():
	# Para correrlo entero, ajustar los flags a READY ! ...
	
	# Los tengo ocultos para que no me molesten...)
	ui_status.show()
	ui_readbox.show()
	
	# Load data and connect signals
	call_deferred("load_data")
	call_deferred("_connect_signals")
	
func _connect_signals():
	link.connect("interact", self, "interactions", ["1"]) #TODO: este bind es para testear. signal debe pasar ID
	link.connect("open_menu", self, "menu")
	link.health.connect("healed", ui_status, "healed") #señal para update de UI
	link.health.connect("damaged", ui_status, "damaged") #señal para update de UI
	link.health.connect("death", self, "game_over")
	Inventory.connect("update_UI", ui_status, "receive_updates")
	Inventory.connect("update_link_hands", link, "update_hands")
	Inventory.connect("menu_close", self, "tree_resume")
	ui_readbox.connect("box_done", self, "tree_resume") #
	input_cd.connect("timeout",self,"allow_input")
	$MapController.teleport_node.connect("go_to", self, "teleport")
	
func interactions(group, id): # TODO branchear segun grupo de interacciòn
	var text_data = {"1":"Santa, debes ver esto."} # armar sistema de almacenamiento y lectura.
	if group == "Sign":
		tree_await()
		show_text_up(text_data[id])
		
func show_text_down(text): # provisoria
	tree_await()
	ui_readbox.write_dialogue_down(text)
	
func show_text_up(text): # provisoria
	tree_await()
	ui_readbox.write_dialogue_up(text)

func tree_await():
	get_tree().paused = true
	allow_input = false

func tree_resume():
	get_tree().paused = false
	input_cd.start()
	
func allow_input():
	allow_input = true
	
func menu():
	get_tree().paused = true
	allow_input = false
	Inventory.open_menu() # handle input there...
	
func _input(event):
	if allow_input and event.is_action_pressed("ui_accept"):
		link.receive_input(event)
	if allow_input and event.is_action_pressed("ui_dev"):
		print($EventManager.event_flags) # puedo hacer un editor de saves despues :D
		
signal queue_free_map
func teleport(direction): # este funciona para cambios tipo mapa overworld. Despuès implementar los otros teleports...
	emit_signal("teleport_start", direction, $MapController.zone)
	link.set_physics_process(false)
	$MapController.update_current_zone(direction)
	#var old_zone = $MapController.update_current_zone(direction)
	camera.movecam(direction)
	yield(camera, "cam_done")
	link.set_physics_process(true)
	emit_signal("queue_free_map")
	#old_zone.queue_free()
	#$MapController.teleport_node.connect("go_to", self, "teleport")
	emit_signal("teleport_done", direction, $MapController.zone)
	$MapController.checkpoint_pos = link.position
	print(link.position)
	
func area_teleport(area, zone, spawn):
	#TODO: en desarrollo...
	emit_signal("teleport_start", Vector2(0,0), $MapController.zone)
	var pepe = load("res://UI/ShaderEnterDoor/EnterDoorEffect.tscn").instance()
	link.set_physics_process(false)
	#TODO start blink
	AudioManager.play_sfx("DungeonTeleport")
	#yield(AudioManager.get_node("SFX"), "finished")
	var pos_spawn = $MapController.update_area(area, zone, spawn) #TODO
	camera.set_camera(Vector2(0,0))
	add_child(pepe)
	pepe.activate_effect()
	link.position = pos_spawn
	yield(pepe, "effect_done")
	#$MapController.teleport_node.connect("go_to", self, "teleport")
	link.set_physics_process(true)
	#pepe.queue_free()
	#TODO yield blink
	emit_signal("teleport_done", Vector2(0,0), $MapController.zone)
	$MapController.checkpoint_pos = link.position
	$MapController.global_checkpoint_pos = link.position - cam_position()
	print(link.position)
	
func get_checkpoint_pos():
	return $MapController.checkpoint_pos
	
func link_got(item): # despues migrar...
	Inventory.new_item(item)
	link.update_hands("A", 1) # es el unico que recibe... en realidad tendrìa que chequear...
			
func game_over():
	link.death()
	yield(link, "anim_playing")
	get_node("/root/SaveLoader").update_current_file() # updateo el temporal.
	get_tree().change_scene("res://TitleScreen/ContinueScreen/ContinueScreen.tscn") #aca deciden si guardar
	
func cam_position():
	return camera.position
	
func load_data():
	# get_node("/root/SaveLoader").load_all_saves() # esto iria por otro lado... #TODO DEV
	var data = get_node("/root/SaveLoader").get_current_data()
	print(data) # DEV
	if data.has("evm"):
		$EventManager.set_data(data["evm"]) 
	else:
		print("no evm in data")
	if data.has("map"):
		$MapController.set_data(data["map"]) 
	else:
		print("no map in data")
	if data.has("player"):
		$Link.set_data(data["player"]) 
		$UI/StatusBar.init_hearts_ui($Link/Health.max_health, $Link/Health.current_health)
	else:
		print("no player in data")
	if data.has("inventory"):
		Inventory.set_data(data["inventory"])
		$UI/StatusBar.receive_updates("R", "rupees", Inventory.rupees)
		if Inventory.hand_B == Inventory.ITEMS.SWORD_L1:
			$UI/StatusBar.receive_updates("B", "sword", 0)
			link.update_hands("A", 1) #only A hand is working...
	else:
		print("no inventory in data")
	$MapController.init_map()
	$EventManager.init_evm()