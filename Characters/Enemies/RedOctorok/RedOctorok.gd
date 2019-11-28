extends KinematicBody2D

export (bool) var turn_on = false

const SPEED = 50
const SHOOT_PROB = 0.5 # uniforme. p entre 0.0 y 1.0
const DIR = ["Down", "Left", "Right", "Up"]
const VEC = {"Up": Vector2(0,-1), "Down": Vector2(0,1),"Left": Vector2(-1,0),"Right": Vector2(1,0)}

onready var Health = $EnemyHealth

var rand = 0
var current_dir = Vector2(0,1)
var wait = false

const attack_damage = 0.25

var knockback_dir = null
var stunned = false

func _ready():
	if turn_on:
		set_physics_process(true)
		$change_dir.connect("timeout", self, "change_dir")
		$change_dir.start()
		$wait_timer.connect("timeout", self, "stop_wait")
		$wait_timer.start()
		var mat = $sprite.get_material().duplicate(true)
		$sprite.set_material(mat)
		#$hitStun.connect("timeout", self, "stun_over")
		$EnemyHealth.connect("enemy_death", self, "death")
		$EnemyHealth.connect("stop_collider", self, "collider_off")
	else:
		set_physics_process(false)
		
func _physics_process(delta):
	if Health.stunned:
		move_and_slide(knockback_dir * SPEED * 2.00)
	elif not wait:
		var collision_info = move_and_collide(VEC[DIR[rand]] * SPEED * delta)
		var is_player = false
		if collision_info:
			is_player = collision_info.collider.is_in_group("Player")
		if collision_info and not is_player:
			rand += 1
			rand %= 4
		elif is_player:
			get_tree().get_root().get_node("Test/Link").collision_handler(self)
		if "Walk_"+ DIR[rand] != $anim.current_animation :
			$anim.play("Walk_"+ DIR[rand])
			current_dir = VEC[DIR[rand]]
	else:
		if $anim.is_playing():
			$anim.stop()
			var rand2 = randi() % int(1/SHOOT_PROB)
			if rand2 == 0:
				throw_projectile()
		
func receive_attack(pos):
		knockback_dir = (global_position - pos).normalized()
		$hitAnimation.play("Hit") # alterna una variable en un shader para mostrar efecto de daño :D
		Health.handle_damage()

func change_dir():
	if not wait:
		rand = randi() % 4
	
func stop_wait():
	wait = not wait
	
func throw_projectile():
	var bullet = load("res://Characters/Enemies/RedOctorok/Bullet.tscn").instance()
	bullet.direction = current_dir
	bullet.position = $Position2D.position
	add_child(bullet)
	
func death():
	set_physics_process(false)
	$change_dir.queue_free()
	$wait_timer.queue_free()
	$anim.queue_free()
	$coll.queue_free()
	$sprite.queue_free()
	var explosion = load("res://Explosions/EnemyExplosion.tscn").instance()
	add_child(explosion)
	yield(explosion.get_node("anim"), "animation_finished")
	queue_free()
	
func collider_off():
	set_collision_mask_bit(8, false)
	