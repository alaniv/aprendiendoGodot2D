extends Node2D

signal area_teleport(area_name, zone)

func _ready():
	$Objects/Door.connect("body_entered", self, "area_teleport")
	
func area_teleport(body):
	emit_signal("area_teleport", "Labrynna_Present", Vector2(10,10), 0)
