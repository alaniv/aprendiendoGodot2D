extends Control

var current_max = 3

var heart_icon = [ # no se si habìa una forma mas optima...
	load("res://UI/StatusBar/heart0.png"), 
	load("res://UI/StatusBar/heart1.png"),
	load("res://UI/StatusBar/heart2.png"),
	load("res://UI/StatusBar/heart3.png"),
	load("res://UI/StatusBar/heart4.png")
]

onready var hearts = $Hearts.get_children()
var max_heart_index = -1
var current_heart_index = -1
var current_heart_status = -1

onready var rupees_display = $NumberRupees

func _ready():
	#receive_updates("B", "sword") # testing
	init_hearts_ui(3, 3)
	
func receive_updates(hand, item, num): # metodo de redirecciòn
	print("received" + hand + item + str(num))
	if hand == "B":
		item_display_B(item, num)
	if hand == "A":
		pass
	if hand == "R":
		rupees_display.set_number(int(num))

func item_display_B(item, num):
	$B/Level.hide() # default
	$B/Number.hide()
	if item == "sword":
		$B.texture = load("res://Items/SwordL1/swordL1_item.png")
		$B/Level.frame = 0
		$B/Level.show()
		# if numeric, check property in inventory(?)
	
func healed(x):
	#TODO
	pass

func damaged(x):
	var damage = int(x*4) #cuantos quarters restar?
	while damage > 0:
		if current_heart_status != 0:
			current_heart_status -= 1
			damage -= 1
		if current_heart_status == 0: #practicamente, si status es 0, lo bajo a status 4 del anterior.
			hearts[current_heart_index].texture = heart_icon[0]
			current_heart_index -= 1
			current_heart_status = 4
	if current_heart_index != -1:
		hearts[current_heart_index].texture = heart_icon[current_heart_status]
	
func init_hearts_ui(max_health, current_health):
	max_heart_index = max_health -1
	for i in range(0, max_health):
		hearts[i].texture = heart_icon[0]
	var delta = (current_health - int(current_health))
	if delta != 0:
		current_heart_index = int(current_health)
		current_heart_status = delta * 4
		for i in range(0, current_heart_index):
			hearts[i].texture = heart_icon[4]
		hearts[current_heart_index].texture = heart_icon[delta]
	else:
		current_heart_index = int(current_health) -1
		current_heart_status = 4
		for i in range(0, current_heart_index+1):
			hearts[i].texture = heart_icon[4]

func init_inventory_ui(data):
	pass