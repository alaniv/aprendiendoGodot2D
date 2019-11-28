extends Node2D

signal healed(amount) #señal para update de UI
signal damaged(amount) #señal para update de UI
signal death #señal para update de GameManager

var current_health = 3.0
var max_health = 3.0
var stunned = false

func _ready():
	$HitStun.connect("timeout", self, "stun_over")
	$LowHealth.connect("timeout", self, "low_health_alert")
	
func init_health(maxH,currH):
	current_health = currH
	maxH = currH
	#TODO: notificar a UI

func decrease_health(damage_amount):
	if current_health > damage_amount:
		current_health -= damage_amount
		emit_signal("damaged", damage_amount)
	else:
		emit_signal("damaged", current_health)
		current_health = 0
		$LowHealth.stop()
		emit_signal("death")
	if current_health == 0.75:
		$HurtSFX/LowHealth.playing = true
		$LowHealth.start()
	
func increase_health(heal_amount):
	if heal_amount >= (max_health - current_health):
		emit_signal("healed", max_health - current_health)
		current_health = max_health
	else:
		current_health += heal_amount
		emit_signal("healed", heal_amount)
	
func handle_damage(dmg, pos):
	stunned = true
	$HitStun.start()
	$hitAnimation.play("Hit") # alterna una variable en un shader para mostrar daño :D
	decrease_health(dmg)
	return ($"..".position - pos).normalized() #knockback direction
	
func stun_over():
	stunned = false
	#$hitAnimation.stop()

func low_health_alert():
	$HurtSFX/LowHealth.playing = true