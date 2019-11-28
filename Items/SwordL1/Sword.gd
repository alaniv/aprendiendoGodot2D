extends Area2D

var sword_ready_for_circle = false
var tapping = false
onready var anim_charge = $sword_charge

onready var fx_slash = [$SFX/SL1, $SFX/SL2, $SFX/SL3]

func _ready():
	$charge_timer.connect("timeout", self, "start_charge")
	connect("body_entered", self, "swrd_coll_handler")
	
func attack():
	var rand = randi() % 3
	fx_slash[0].playing = false
	fx_slash[1].playing = false
	fx_slash[2].playing = false
	fx_slash[rand].playing = true
	
func tap():
	tapping = true
	$SFX/Tap.playing = true
	stop_charge()
	sword_charge_start()
	yield($SFX/Tap, "finished") #importante!
	tapping = false
	
func sword_charge_start():
	# reset por si acaso...
	$coll.disabled = true
	anim_charge.stop()
	sword_ready_for_circle = false
	$Sprite.frame = 1
	$charge_timer.stop()
	visible = true
	$charge_timer.start()


func start_charge():
	$SFX/Charge.playing = false
	$SFX/Charge.playing = true
	anim_charge.play("Charge")
	sword_ready_for_circle = true
	
func start_circle():
	$SFX/Spin.playing = false
	$SFX/Spin.playing = true
	anim_charge.stop()
	#visible = false
	sword_ready_for_circle = false
	$Sprite.frame = 1
	
func stop_charge():
	$coll.disabled = true
	visible = false
	sword_ready_for_circle = false
	$sword_charge.stop()
	$Sprite.frame = 1
	$charge_timer.stop()
	
func swrd_coll_handler(body):
	if body.is_in_group("Bush"):
		body.cut()
	if body.is_in_group("Enemy"):
		body.receive_attack(get_parent().get_parent().global_position) # link's position