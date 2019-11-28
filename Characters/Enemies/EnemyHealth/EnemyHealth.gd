extends Node2D

signal enemy_death
signal stop_collider

var current_health = 1.5
var max_health = 1.5
var sword_damage = 0.5 # esto deberìa ir en un sword.tscn en realidad...
var stunned = false

func _ready():
	$hitStun.connect("timeout", self, "stun_over")
	
func decrease_health(damage_amount):
	if current_health > damage_amount:
		current_health -= damage_amount
	else:
		emit_signal("stop_collider")
		current_health = 0
		yield($hitStun, "timeout")
		emit_signal("enemy_death")
		$SFX/Hit.playing = false
		$SFX/Die.playing = true # mejorar esto.
	
func handle_damage(): # TODO: add dmg and pos in variable
	decrease_health(sword_damage)
	stun_start()
	# TODO: move code from parent class. return ($"..".position - pos).normalized() #knockback direction
	
func stun_over():
	stunned = false
	
func stun_start():
	$SFX/Hit.playing = true
	stunned = true
	$hitStun.start()