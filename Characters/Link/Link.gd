extends KinematicBody2D

# Esta clase me quedo re contra chota, pero la funcionalidad anda bien. Refactorizar! D:
var player_name = "Link"

# signal accept
signal interact(group)
signal anim_playing

const FACE = {"Up": "Up", "Down": "Down","Left": "Left", "Right": "Right", "None":"None"}
const DIR = {"Up": Vector2(0,-1), "Down": Vector2(0,1),"Left": Vector2(-1,0),"Right": Vector2(1,0), "None": Vector2(0,0) }
const STATUS = {"Idle": "Idle", "Walk": "Walk", "Push": "Push", "Tap": "Tap"} 

enum ITEMS {NONE, SWORD_L1, SHIELD, SHOVEL} # copiarlo asì? o importarlo?
var hand_A = ITEMS.NONE # debe sincronizar con inventario
var hand_B = ITEMS.NONE # debe sincronizar con inventario

var current_status = STATUS.Idle
var face_direction = FACE.Down
const SPEED = 50
var allow_input = true
var pause_input = false
var charging_A = false

onready var health = $Health
var knockback_dir = null

func _ready():
	$animator.connect("animation_finished", self, "allow_input")

func _physics_process(delta):
	# el unico bug que me queda: si hago release del charge mientras teleportea, pierde el evento.
	# El juego original hace un queue por lo que veo. Ver como implementar eso. Tengo que cambiar pause/unpause 
	# para que no me freezee physics_process, y pueda queuear eso...
	
	# Bug 2: en el teleport, se pierde just_pressed. Todos los bugs que tengo son por eso. 
	# Este se arregla ignorando press sin just.. otro flag? :/
	if pause_input: return
	if not allow_input:
		if hand_A == ITEMS.SWORD_L1:
			if Input.is_action_just_pressed("Action_A"): # por ahora una excepcion chota. Despues lo arreglo...
				pressA()
			return
	if Input.is_action_just_pressed("Action_A"):
		if hand_A == ITEMS.SWORD_L1:
			pressA()
			return
	if Input.is_action_pressed("Action_A") and not charging_A:
		if hand_A == ITEMS.SWORD_L1:
			charging_A = true
			$Weapons.visible = true
			$Weapons/Sword.sword_charge_start()
	if not charging_A:
		if hand_A == ITEMS.SWORD_L1:
			$Weapons.visible = false
	if Input.is_action_just_released("Action_A"):
		if hand_A == ITEMS.SWORD_L1:
			$Weapons.visible = false
			releaseA()
			return
	var velocity = Vector2() # the player's movement vector
	var anim = current_status
	var face = face_direction
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	
	match velocity:
		DIR.None:
			# face direction must not be updated!
			anim = STATUS.Idle
		DIR.Up:
			face = FACE.Up
			anim = STATUS.Walk
		DIR.Down:
			face = FACE.Down
			anim = STATUS.Walk
		DIR.Right:
			face = FACE.Right
			anim = STATUS.Walk
		DIR.Left:
			face = FACE.Left
			anim = STATUS.Walk
		_:
			anim = STATUS.Walk
			if DIR[face_direction].dot(velocity) < 0:
				# in case of conflict(fast 2 keys, other directions) reset anim to x axis...
				if velocity.x == 1:
					face = FACE.Right
				else:
					face = FACE.Left
					
	if health.stunned:
		move_and_slide(knockback_dir * SPEED * 1.25)
	
	var collision_info = move_and_collide( velocity.normalized() * delta * SPEED)
	if collision_info:
		collision_handler(collision_info.collider)
		#If son paredes:
		if collision_info.normal.dot(DIR[face_direction]) == 0: # _|_
			move_and_slide(velocity.normalized()*SPEED)
			if current_status == STATUS.Push: #Fix for corner collisions with 2 walls.
				anim = STATUS.Push
		elif collision_info.normal.dot(DIR[face_direction]) == -1: # // 
			anim = collision_handler(collision_info.collider)
			move_and_slide(velocity.slide(collision_info.normal).normalized()*SPEED*0.8)
		else:
			pass # este tipo de colisiones las ignoro.
			
	if charging_A:
		face = face_direction
			
	if anim != current_status or face_direction != face:
		current_status = anim
		face_direction = face
		if current_status in [STATUS.Idle, STATUS.Push, STATUS.Walk]:
			$animator.play(current_status + "_" + face_direction)

	elif anim == STATUS.Tap:
		current_status = anim
		face_direction = face
		if not $Weapons/Sword.tapping:
			$animator.play(current_status + "_" + face_direction)
			$Weapons/Sword.tap()
			#yield($animator, "animation_finished")
		#print(current_status + "_" + face_direction) #DEBUG
		
signal open_menu
func receive_input(event):
	if not allow_input:
		return
	if event.is_action_pressed("ui_accept"):
		if $RayCast2D.is_colliding():
			#print($RayCast2D.get_collider().name) #DEBUG 
			if $RayCast2D.get_collider().is_in_group("Sign"):
				emit_signal("interact", "Sign")
		else:
			emit_signal("open_menu")
			#emit_signal("accept")
			
func allow_input(x): # x = ?
	allow_input = true
	
func update_hands(hand, item_code):
	print("yee")
	if hand == "A":
		hand_A = item_code
	elif hand == "B":
		hand_B = item_code
		
func pressA():
	allow_input = false
	current_status = "Attack"
	$animator.play("Attack_" + face_direction)
	$Weapons/Sword.attack()
	
func releaseA():
	allow_input = false
	if $Weapons/Sword.sword_ready_for_circle:
		$Weapons/Sword.start_circle()
		current_status = "CircleAttack"
		$animator.play("CircleAttack_" + face_direction)
		yield($animator, "animation_finished")
		charging_A = false
	else:
		current_status = "Idle"
		$animator.play("Idle_" + face_direction)
		$Weapons/Sword.stop_charge()
		charging_A = false
	allow_input = true

func collision_handler(collider):
	# TODO: definir convenciones: Grupo -> metodo canonico de interacciòn con un elem de grupo.
	if collider.is_in_group("Block"):
		if charging_A:
			#return STATUS.Walk
			return STATUS.Tap # TODO: EXPERIMENTAL
		collider.try_push_block()
		return STATUS.Push
	elif collider.is_in_group("Npc"): 
		return STATUS.Walk
	elif collider.is_in_group("Barrier"):
		collider.barrier_notify()
		return STATUS.Walk
	elif collider.is_in_group("Enemy") or collider.is_in_group("EnemyAttack"):
		var dmg = collider.attack_damage
		var pos = collider.global_position
		if not health.stunned:
			knockback_dir = health.handle_damage(dmg, pos)
			health.get_node("HurtSFX/Hurt").playing = true
		return STATUS.Walk # despues modificar
	# TODO: Este es un metodo de peso completo. Completarlo...
	else: #Una pared debiera ser el default. y quiero pushearla...
		if charging_A:
			#return STATUS.Walk
			return STATUS.Tap # TODO: EXPERIMENTAL
		return STATUS.Push
		
func pause():
	set_physics_process(false)
	pause_input = true
	$CollisionShape2D.disabled = true
	
var final_pause = false # un fix para un error molesto...
	
func unpause():
	if final_pause: return
	set_physics_process(true)
	allow_input = true
	pause_input = false
	$CollisionShape2D.disabled = false
	
func set_status_idle():
	current_status = STATUS.Idle
	face_direction = FACE.Down
	$animator.play(current_status + "_" + face_direction)
	
func play_anim(anim_name):
	$animator.play(anim_name)
	emit_signal("anim_playing")
	
func death():
	pause()
	final_pause = true
	$Weapons.visible = false
	$animator.play("Death")
	health.get_node("HurtSFX/Death").playing = true
	yield($animator, "animation_finished")
	emit_signal("anim_playing") # en realidad played... quiero ahorrar.
	
### tween externos durante escenas.
onready var tween_pos = $tween_pos

func tween_position(delta_pos, time, type):
	tween_pos.interpolate_property(self, "position",
        position, position + delta_pos, time,
        type, Tween.EASE_IN_OUT)
	tween_pos.start()
	
# Metodos de guardado.
func init_link():
	# iria un init health. Y sincronizaciones con UI ?
	pass
	
func get_data():
	var dic_player = {}
	dic_player["max_health"] = $Health.max_health
	dic_player["current_health"] = $Health.current_health
	dic_player["name"] = player_name
	return dic_player
	
func set_data(data):
	player_name = data["name"]
	$Health.current_health = data["current_health"]
	if data["current_health"] == 0: # restorear si murio...
		$Health.current_health = 3
	$Health.max_health = data["max_health"]
	
func drown():
	pause()
	$animator.stop()
	$Drown.play("Drown_" + face_direction)
	yield($Drown, "animation_finished")
	if $"..".has_method("get_checkpoint_pos"):
		position = $"..".get_checkpoint_pos() 
	else: # para no romper modularidad...
		position = Vector2(32,32)
	$animator.play("Idle_" + face_direction)
	current_status = STATUS.Idle
	knockback_dir = health.handle_damage(0.50, self.position)
	yield($Health/hitAnimation, "animation_finished")
	unpause()
	
func fall(vect): #agrupar con el metodo anterior...
	tween_position(vect - self.global_position, 1.0, Tween.TRANS_LINEAR)
	yield(tween_pos,"tween_completed")
	pause()
	$animator.stop()
	$Drown.play("Fall")
	yield($Drown, "animation_finished")
	if $"..".has_method("get_checkpoint_pos"):
		position = $"..".get_checkpoint_pos() 
	else: # para no romper modularidad...
		position = Vector2(32,32)
	$animator.play("Idle_" + face_direction)
	current_status = STATUS.Idle
	knockback_dir = health.handle_damage(0.50, self.position)
	yield($Health/hitAnimation, "animation_finished")
	unpause()