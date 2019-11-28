extends Area2D

func _ready():
	connect("body_entered", self, "pit")

func pit(body):
	if body.is_in_group("Player"):
		var dist = 100.0;
		var area = null
		for elem in self.get_children(): # busco el area mas cercana para lerp
			var d2 = (body.global_position - elem.global_position).length()
			if d2 < dist:
				dist = d2
				area = elem
		body.fall(area.global_position)
