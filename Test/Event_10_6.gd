extends "res://Event/Event.gd"

onready var timer = $Timer
onready var octs = $Octoroks.get_children()
onready var impa = $Impa

func _ready():
	octs[0].get_node("anim").play("Walk_Right", -1, 0.5)
	octs[1].get_node("anim").play("Walk_Down",-1, 0.5)
	octs[2].get_node("anim").play("Walk_Left",-1, 0.5)
	impa.get_node("anim").play("Walk_Down_P",-1, 0.5)
	self.position = self.camera_next_position # setear inicio en la posicion post teleport.
	link.pause()

func start():
	_text_down("HELLLLLLP!!!!")
	yield(GameManager, "teleport_done")
	_play_song("ImpaOddArrival")
	time_sleep(2.0)
	yield(timer, "timeout")
	link_walk_left(link)
	yield(link.tween_pos, "tween_completed")
	link_walk_forward(link)
	yield(link.tween_pos, "tween_completed")
	link.play_anim("Idle_Up")
	octs[0].get_node("anim").play("Walk_Left", -1, 1.0)
	octs[1].get_node("anim").play("Walk_Up",-1, 1.0)
	octs[2].get_node("anim").play("Walk_Up",-1, 1.0)
	_play_sfx("Tap")
	time_sleep(1.0)
	yield(timer, "timeout")
	enemy_run(octs[0], Vector2(-120,0))
	yield($Tween, "tween_completed")
	enemy_run(octs[1], Vector2(0,-120))
	yield($Tween, "tween_completed")
	enemy_run(octs[2], Vector2(0,-120))
	yield($Tween, "tween_completed")
	for oct in octs:
		oct.queue_free()
	"""
	var file = File.new() ### Despues lo migro a un sistema mejor. Es temporal...
	file.open("res://Texts/test.txt", File.READ)
	var string = file.get_as_text()
	GameManager.show_text_up(string) ###
	"""
	_text_up("Thanks. This is a test.")
	link.unpause()
	impa.is_possessed = true
	impa.npc_follow(link, self.position)
	
func start_stage1(fr_position):
	impa.npc_follow_active = false
	var new_position = GameManager.cam_position() - self.position + fr_position # vector math :D
	link.pause()
	#TODO: PLAY IMPA JUMP UP AIMATION
	_text_up("Oh! That's it!") 
	impa.tween_position(new_position - impa.position, 1.0, Tween.TRANS_LINEAR)
	yield(impa.tween_pos, "tween_completed")
	impa.get_node("anim").play("Walk_Up_P",-1, 0.5)
	time_sleep(0.1)
	yield(timer, "timeout")
	_text_up("This rock with the > sign!") 
	link_walk_left(link)
	yield(link.tween_pos, "tween_completed")
	link_walk_forward(link)
	yield(link.tween_pos, "tween_completed")
	impa.get_node("coll").disabled = false
	impa.get_node("anim").play("Walk_Down_P",-1, 0.5)
	time_sleep(0.1)
	yield(timer, "timeout")
	_text_up("Could you move this rock for me, Ivo?") # despues upgradear esto
	time_sleep(0.2)
	yield(timer, "timeout")
	impa.get_node("anim").play("Walk_Right_P",-1, 0.5)
	impa.tween_position(Vector2(-16,0), 1.0, Tween.TRANS_LINEAR)
	yield(impa.tween_pos, "tween_completed")
	_text_up("I'll... um... I'll just...") # despues upgradear esto
	impa.tween_position(Vector2(-16,0), 1.0, Tween.TRANS_LINEAR)
	yield(impa.tween_pos, "tween_completed")
	time_sleep(0.2)
	yield(timer, "timeout")
	_text_down("I can't do it...")
	link.unpause()
	# TODO: Hablarle a Impa ahora deberìa darme : "What are you doing?\nHurry up and move this!"
	
func start_stage2(fr_position):
	var new_position = GameManager.cam_position() - self.position + fr_position# vector math :D
	link.pause()
	impa.tween_position(Vector2(0,16), 0.5, Tween.TRANS_LINEAR)
	yield(impa.tween_pos, "tween_completed")
	impa.tween_position(new_position + Vector2(0,16) - impa.position, 0.5, Tween.TRANS_LINEAR)
	yield(impa.tween_pos, "tween_completed")
	impa.get_node("anim").play("Walk_Up_P",-1, 0.5)
	impa.tween_position(new_position - impa.position, 0.5, Tween.TRANS_LINEAR)
	yield(impa.tween_pos, "tween_completed")
	_text_down("Thank you... Now let's go...")
	link.unpause()
	impa.npc_follow(link, self.position)
	
func start_stage3():
	_play_song("NayruSong")

func link_walk_left(link):
	var delta_pos = Vector2((self.position + $Impa.position).x, link.position.y) - link.position
	link.tween_position(delta_pos, 1.0, Tween.TRANS_LINEAR)
	link.play_anim("Walk_Left")

func link_walk_forward(link):
	var delta_pos = self.position + $Impa.position + Vector2(0,16) - link.position # fea... y con globals?
	link.tween_position(delta_pos, 1.0, Tween.TRANS_LINEAR)
	link.play_anim("Walk_Up")
	
func enemy_run(oct, position):
	_play_sfx("Throw")
	oct.get_node("coll").disabled = true
	$Tween.interpolate_property(oct, "position",
        oct.position, oct.position + position, 0.5,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
func time_sleep(time): # poner el yield tras llamarla, si no no sirve.
	timer.set_wait_time( time )
	timer.start()
	
func notify_event(stage):
	if stage == 0:
		print("stage0")
		start()
	if stage == 1:
		print("stage1")
		var vec = GameManager.get_node("MapController/zone_9_8/EventTriggers/Front").position #TODO
		start_stage1(vec)
	if stage == 2:
		print("stage2")
		var vec = GameManager.get_node("MapController/zone_9_8/EventTriggers/Front").position #TODO
		start_stage2(vec)
	if stage == 3:
		print("stage3")
		start_stage3()
	if stage == 4:
		print("end")
		queue_free()

	