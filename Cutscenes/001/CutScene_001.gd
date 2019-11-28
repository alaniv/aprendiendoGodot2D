extends Node2D

onready var anim = $AnimationPlayer
onready var tween = $Tween

func _ready():
	anim.play("RotatingFixed")
	var road = $road
	tween.interpolate_property(road, "position", road.position, road.position + Vector2(0,60), 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	$ReadBox.write_dialogue_down("Accept our quest Hero!")
	yield($ReadBox, "box_done")
	anim.play("Falling")
	var aura = $road/Character/Blue_Aura
	tween.interpolate_property(aura, "scale", aura.scale, Vector2(0.2,0.2), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	$Gasha.playing = true
	yield($Gasha, "finished")
	get_tree().change_scene("res://Test/Test.tscn")

