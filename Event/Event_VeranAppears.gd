extends "res://Event/Event.gd"

onready var nayru = $Nayru
onready var ralph = $Ralph
onready var impa = $Impa
onready var rab1 = $Animals/Rabbit
onready var rab2 = $Animals/Rabbit2
onready var parrot = $Animals/Parrot
onready var bear = $Animals/Bear
onready var monkey = $Animals/Monkey

func _ready():
	self.position = camera_current_position
	link.global_position = $pos.global_position
	link.play_anim("Idle_Right")
	link.pause()
	
func animals_look_down():
	rab1.get_node("anim").play("Down")
	rab2.get_node("anim").play("Down")
	monkey.get_node("anim").play("Down",-1,0.5)
	bear.get_node("anim").play("Down")
	
func play_part_2():
	_play_song("OddHappening")
	_play_sfx("BossDie")
	$scene_anim.play("Part2")
	$Night.night(1.0)
	yield(self, "sfx_finished")
	_play_song("RoomOfRites")
	
func free_animals():
	$scene_anim.play("Part3")
	$Animals.queue_free()
	
func animals_run():
	print("animals run")
	rab1.get_node("anim").play("Right")
	rab2.get_node("anim").play("Right")
	parrot.get_node("anim").play("Fly_Right")
	bear.get_node("anim").play("Up")
	monkey.get_node("anim").play("Run")
	
func link_walk_left():
	_link_walk_left(link, $pos2.position) # poner un Tween
	
func _link_walk_left(link, pos):
	var delta_pos = Vector2((pos.x + self.position.x) - link.position.x, 0)
	link.tween_position(delta_pos, 0.6, Tween.TRANS_LINEAR)
	link.play_anim("Walk_Left")
	yield(link.tween_pos, "tween_completed")
	_link_walk_down(link, pos)

func _link_walk_down(link, pos):
	link.play_anim("Walk_Down")
	var delta_pos = Vector2(0, (pos.y + self.position.y) - link.position.y)
	link.tween_position(delta_pos, 0.3, Tween.TRANS_LINEAR)
	yield(link.tween_pos, "tween_completed")
	
func walk_to_impa():
	_stop_song()
	print("walk to impa")
	_link_walk_left(link, $pos3.position)
	link.play_anim("Idle_Left")
	
func write_up(index):
	if index == 4:
		animals_look_down()
		link.play_anim("Idle_Down")
		_text_up("Impa se rie")
		yield(self, "text_read")
	if index == 5:
		link.play_anim("Idle_Down")
		_text_up("Impa habla")
		yield(self, "text_read")
	if index == 6:
		link.play_anim("Idle_Down")
		_text_up("Veran Fantasma habla")
		yield(self, "text_read")
	if index == 18:
		link.play_anim("Idle_Left")
		_text_up("Impa habla")
		yield(self, "text_read")
	if index == 19:
		link.play_anim("Idle_Left")
		_text_up("Impa habla 2")
		yield(self, "text_read")
	if index == 20:
		link.get_node("Sprite").frame = 2
		_text_up("Impa habla 3. Da espada")
		yield(self, "text_read")
		link.get_node("Sprite").frame = 18
		_play_sfx("Fanfare")
		$SwordItem.visible=true
		_text_up("You got a Hero's Wooden Sword!")
		GameManager.link_got("sword")
		yield(self, "text_read")
		$SwordItem.visible=false
	if index == 21:
		link.play_anim("Idle_Left")
		_text_up("Impa habla 4")
		yield(self, "text_read")
		link.unpause()
		yield($scene_anim, "animation_finished")
		_play_song("Overworld")
		self.queue_free()
	
func write_down(index):
	if index == 0:
		link.play_anim("Idle_Right")
		_text_down("Ralph habla")
		yield(self, "text_read")
		link.play_anim("Idle_Up")
	if index == 1:
		_text_down("Nayru habla")
		yield(self, "text_read")
		link.play_anim("Idle_Right")
	if index == 2:
		_text_down("Ralph habla")
		yield(self, "text_read")
		link.play_anim("Idle_Up")
	if index == 3:
		_text_down("Nayru habla")
		yield(self, "text_read")
	if index == 7:
		_play_sfx("Slash1")
		link.play_anim("Idle_Up")
		_text_down("Ralph habla")
		yield(self, "text_read")
	if index == 8:
		link.play_anim("Idle_Up")
		_text_down("Nayru Poseida habla")
		yield(self, "text_read")
	if index == 9:
		link.play_anim("Idle_Up")
		_text_down("Nayru Poseida habla 2 ")
		yield(self, "text_read")
	if index == 10:
		link.play_anim("Idle_Left")
		_text_down("Nayru Poseida habla")
		yield(self, "text_read")
	if index == 11:
		link.play_anim("Idle_Left")
		_text_down("Nayru Poseida habla una ultima vez...")
		yield(self, "text_read")
		var cs = load("res://Cutscenes/003/Cutscene_003.tscn").instance() # TODO. revisar un tema con el input...
		GameManager.get_node("CutScenePlaceHolder").add_child(cs)
		yield(cs, "done")
		print("scene done")
		$scene_anim.play("Part5")
		_play_song("SadTheme")
	if index == 12:
		link.play_anim("Idle_Up")
		_text_down("Ralph habla")
		yield(self, "text_read")
	if index == 13:
		link.play_anim("Idle_Up")
		_text_down("Ralph habla")
		yield(self, "text_read")
	if index == 14:
		link.play_anim("Idle_Up")
		_text_down("Ralph habla")
		yield(self, "text_read")
	if index == 15:
		link.play_anim("Idle_Up")
		_text_down("Ralph habla")
		yield(self, "text_read")
	if index == 16:
		link.play_anim("Idle_Up")
		_text_down("Ralph habla")
		yield(self, "text_read")

func blink():
	link.play_anim("Idle_Up")
	_play_sfx("EnemyDie")
	$FadeToWhite.blink()
	$scene_anim.play("Part4")
	
func sun_back():
	$Night.anti_night(1.0)
	yield($Night, "anti_night_done") #TESTING
	
func lightning():
	link.play_anim("Idle_Left")
	_play_sfx("Lightning")
	GameManager.get_node("MapController/zone_9_10").show_portal_active() # TODO migrar esto...
	
func veran_shapeshift(num):
	if num == 1:
		_play_sfx("DungeonTeleport")
		yield(self, "sfx_finished")
		_play_sfx("Shimmer")
		yield(self, "sfx_finished")
	elif num == 2:
		_play_sfx("DungeonTeleport")
		yield(self, "sfx_finished")
		
func shimmer():
	_play_sfx("Shimmer")
	yield(self, "sfx_finished")