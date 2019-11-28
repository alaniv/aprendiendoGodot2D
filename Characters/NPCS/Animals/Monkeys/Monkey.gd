extends KinematicBody2D

export (bool) var orange = false
enum E {Down, Back}
export (E) var initial_animation = E.Down

func _ready():
	var modifier = "" if orange else "_R"
	if initial_animation == E.Down:
		$anim.play("Down" + modifier, -1, 0.25)
	elif initial_animation == E.Back:
		$anim.play("Back" + modifier, -1, 0.25)
