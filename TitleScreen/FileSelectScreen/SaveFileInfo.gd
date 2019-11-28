extends Control

var slot_is_free = [true, true, true]
onready var heart = load("res://TitleScreen/FileSelectScreen/heart.png")
onready var save_cards = [$Save1_Card, $Save2_Card, $Save3_Card]

func _ready():
	get_node("/root/SaveLoader").load_all_saves()
	$anim_timer.connect("timeout", self, "anim_loop")
	call_deferred("cards_init")
	
func cards_init():
	var game_data = get_node("/root/SaveLoader").game_data
	create_cards(game_data)
	show_sf_info(0)

func show_sf_info(file):
	$anim_timer.start()
	if file == -1:
		save_cards[0].hide()
		save_cards[1].hide()
		save_cards[2].hide()
	else:
		save_cards[0].hide()
		save_cards[1].hide()
		save_cards[2].hide()
		save_cards[file].show()
	
func is_empty(num):
	return slot_is_free[num]
	
func fill(num, player_name):
	slot_is_free[num] = false
	get_node("/root/SaveLoader").create_new_file(num, player_name)
	cards_init()
	
func delete_save(num):
	slot_is_free[num] = true
	get_node("/root/SaveLoader").delete_file(num)
	cards_init()

func create_cards(game_data):
	_update_card(save_cards[0], game_data[0], 0)
	_update_card(save_cards[1], game_data[1], 1)
	_update_card(save_cards[2], game_data[2], 2)
	_update_names(game_data)
	
func _update_card(elem, game_data_elem, id):
	# print(game_data_elem)
	if game_data_elem == null:
		elem.get_node("Link").frame = 0
		slot_is_free[id] = true
		elem.get_node("Hearts").hide()
		elem.get_node("Number").hide()
	else:
		slot_is_free[id] = false
		elem.get_node("Link").frame = 2
		fill_hearts(elem.get_node("Hearts"), game_data_elem["player"]["max_health"])
		elem.get_node("Number").set_number(int(game_data_elem["inventory"]["rupees"]))
		elem.get_node("Hearts").show()
		elem.get_node("Number").show()
		
func _update_names(game_data_elem):
	$Name1.text = ""
	$Name2.text = ""
	$Name3.text = ""
	if game_data_elem[0] != null:
		$Name1.text = game_data_elem[0]["player"]["name"]
	if game_data_elem[1] != null:
		$Name2.text = game_data_elem[1]["player"]["name"]
	if game_data_elem[2] != null:
		$Name3.text = game_data_elem[2]["player"]["name"]
		
func anim_loop():
	var sprites = [$Save1_Card/Link, $Save2_Card/Link, $Save3_Card/Link]
	for i in range(0,3):
		if sprites[i].frame == 1: # walk anim
			sprites[i].frame = 2
		elif sprites[i].frame == 2: # walk anim
			sprites[i].frame = 1
		
func fill_hearts(elem, num):
	var hearts = elem.get_children()
	for i in range(0, num):
		hearts[i].texture = heart
	