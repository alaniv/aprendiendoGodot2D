extends Area2D

func _ready():
	connect("body_entered", self, "water")

func water(body):
	if body.is_in_group("Player"):
		body.drown()
