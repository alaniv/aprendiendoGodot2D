extends KinematicBody2D

onready var tween_pos = $tween_pos

var npc_follow_active = false
var npc_target = null
var npc_origin = null

const SPEED = 45
var current_status = STATUS.Idle
var face_direction = FACE.Down

const FACE = {"Up": "Up", "Down": "Down","Left": "Left", "Right": "Right", "None":"None"}
const DIR = {"Up": Vector2(0,-1), "Down": Vector2(0,1),"Left": Vector2(-1,0),"Right": Vector2(1,0), "None": Vector2(0,0) }
const STATUS = {"Idle": "Idle", "Walk": "Walk", "Push": "Push"} 

const POSSESED = "_P"
var is_possessed = false

func _physics_process(delta):
	if npc_follow_active:
		var direction = (npc_target.position - npc_origin) - position
		select_anim(direction)
		if direction.length() > 16.0:
			move_and_slide(direction.normalized() * SPEED)
			
func npc_follow(target, origin):
	$coll.disabled = true
	npc_follow_active = true
	npc_target = target
	npc_origin = origin
	
func select_anim(direction):
	var anim = current_status
	var face = face_direction
	
	if not direction.length() > 16.0:
		anim = STATUS.Idle
	else:
		if direction.normalized().dot(DIR.Up) > 0.71:
			face = FACE.Up
			anim = STATUS.Walk
		elif direction.normalized().dot(DIR.Down) > 0.71:
			face = FACE.Down
			anim = STATUS.Walk
		elif direction.normalized().dot(DIR.Right) > 0.71:
			face = FACE.Right
			anim = STATUS.Walk
		elif direction.normalized().dot(DIR.Left) > 0.71:
			face = FACE.Left
			anim = STATUS.Walk
		else:
			anim = STATUS.Walk
			if DIR[face_direction].dot(direction) < 0:
				# in case of conflict(fast 2 keys, other directions) reset anim to x axis...
				if direction.x > 0:
					face = FACE.Right
				else:
					face = FACE.Left
					
	if anim != current_status or face_direction != face:
		current_status = anim
		face_direction = face
		if is_possessed:
			$anim.play(current_status + "_" + face_direction + POSSESED)
		else:
			$anim.play(current_status + "_" + face_direction)
			
func tween_position(delta_pos, time, type):
	tween_pos.interpolate_property(self, "position",
        position, position + delta_pos, time,
        type, Tween.EASE_IN_OUT)
	tween_pos.start()
	