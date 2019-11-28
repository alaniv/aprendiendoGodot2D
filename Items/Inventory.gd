extends Node2D

signal update_UI(hand, item, num)
signal update_link_hands(hand, item_code) # num es para pasar cantidades de objetos

enum ITEMS {NONE, SWORD_L1, SHIELD, SHOVEL} # todo: agregar...

var rupees = 0
var hand_A = ITEMS.NONE
var hand_B = ITEMS.NONE
var items = []

func _ready():
	#uncomment after debug
	set_process_input(false)
	$ItemMenu/M1.hide()
	$ItemMenu/M2.hide()
	$ItemMenu/M3.hide()
	

func new_item(name):
	if name == "sword":
		emit_signal("update_UI", "B", "sword", 0)
		emit_signal("update_link_hands", "B", ITEMS.SWORD_L1)
		hand_B = ITEMS.SWORD_L1
		items.append(ITEMS.SWORD_L1)
	if name == "rupee1":
		rupees += 1
		update_rupees_ui()

func update_rupees_ui():
	emit_signal("update_UI", "R", "rupees", rupees)
	
func get_data():
	var dic_inv = {}
	dic_inv["rupees"] = rupees
	dic_inv["hand_A"] = hand_A
	dic_inv["hand_B"] = hand_B
	dic_inv["items"] = items
	return dic_inv
	
func set_data(dic_inv):
	rupees= dic_inv["rupees"]
	hand_A = dic_inv["hand_A"]
	hand_B = dic_inv["hand_B"]
	items = dic_inv["items"]
	emit_signal("update_link_hands", "A", hand_A)
	emit_signal("update_link_hands", "B", hand_B)

var active_menu = 1
func open_menu():
	$FadeToWhite.play(3.0)
	yield($FadeToWhite/AnimationPlayer, "animation_finished")
	$FadeToWhite.play_reverse(3.0)
	set_process_input(true)
	$ItemMenu/M1.show()
	$ItemMenu/M2.show()
	$ItemMenu/M3.show()
	active_menu = 1
	$ItemMenu/M1.set_process_input(true)
	
signal menu_close
var wait = false
func _input(event):
	if event.is_action_pressed("ui_accept") and not wait: # open save screen.
		wait = true
		set_process_input(false)
		$FadeToWhite.play(3.0)
		yield($FadeToWhite/AnimationPlayer, "animation_finished")
		$FadeToWhite.play_reverse(3.0)
		$ItemMenu/M1.hide()
		$ItemMenu/M2.hide()
		$ItemMenu/M3.hide()
		emit_signal("menu_close")
		$AlternateMenus.play("SetDefault")
		wait = false
	elif event.is_action_pressed("Action_Select") and not wait:
		wait = true
		get_node("ItemMenu/M" + str(active_menu)).set_process_input(false)
		print(active_menu)
		$AlternateMenus.play("Change"+str(active_menu),-1, 2.0, false)
		yield($AlternateMenus, "animation_finished")
		active_menu = active_menu + 1
		if active_menu > 3: active_menu = 1
		get_node("ItemMenu/M" + str(active_menu)).set_process_input(true)
		wait = false
	# otros inputs los manejo directamente en cada screen