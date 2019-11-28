extends Node2D

# this script will be an AUTOLOAD

var selected_file = 0 # valids : 0, 1, 2
var game_data = {0:null, 1:null, 2:null}

func load_all_saves():
	save_dir_create_if_needed()
	load_file(0)
	load_file(1)
	load_file(2)
	
func mem_free():
	# TODO: eventualmente quiero liberar los datos cargados(tras leerlos por ej.).
	pass

func update_current_file():
	#TODO: get relevant data...
	var dic = {}
	dic["evm"] = get_node("/root/Test/EventManager").get_data()
	dic["map"] = get_node("/root/Test/MapController").get_data()
	dic["player"] = get_node("/root/Test/Link").get_data()
	dic["inventory"] = get_node("/root/Test/Inventory").get_data()
	game_data[selected_file] = dic
	
func save_current_file():
	save_file(selected_file)
	
func get_current_data():
	return game_data[selected_file]

func load_file(id):
	var file = File.new()
	if not file.file_exists("user://Save/save_" + str(id) + ".sav"):
		print("no encontre la filesave " + str(id))
	else:
		file.open("user://Save/save_" + str(id) + ".sav", File.READ)
		var string = file.get_as_text()
		file.close()
		game_data[id] = data_to_dic(string)

func save_file(id):
	print("save")
	save_dir_create_if_needed()
	var file = File.new()
	file.open("user://Save/save_" + str(id) + ".sav", File.WRITE)
	file.store_string(to_json(game_data[id]))
	file.close()
	
func save_dir_create_if_needed():
	var directory = Directory.new()
	if not directory.dir_exists("user://Save"):
		directory.open("user://")
		directory.make_dir("Save")
		
func data_to_dic(string):
	return parse_json(string)
	
func load_next_scene():
	if game_data[selected_file].has("new"):
		get_tree().change_scene("res://Cutscenes/001/CutScene_001.tscn")
	else:
		get_tree().change_scene("res://Test/Test.tscn")
		
func create_new_file(num, player_name):
	game_data[num] = {
		"new": true,
		 "inventory":{"hand_A":0,"hand_B":0,"items":[],"rupees":0},
		 "player":{"current_health":3,"max_health":3,"name":player_name}
		}
	save_file(num)
	
func delete_file(id):
	print("try?" + str(id))
	var file = Directory.new()
	if file.file_exists("user://Save/save_" + str(id) + ".sav"):
		print("true")
		file.remove("user://Save/save_" + str(id) + ".sav")
		game_data[id] = null
