extends Area2D

onready var grass_walk_node = Sprite.new()
var body_inside = false

func _ready():
	connect("body_entered", self, "grass_walk")
	connect("body_exited", self, "grass_walk")
	connect("area_entered", self, "cut") # deberìa ser solo la espada.
	grass_walk_node.texture = load("res://Maps/Labrynna_Present/CommonObjects/Grass/GrassWalk.png")

func grass_walk(body):
	if not body_inside:
		body_inside = true
		body.add_child(grass_walk_node)
	else:
		body_inside = false
		body.remove_child(grass_walk_node)
		
func cut(area):
	$coll.disabled = true
	disconnect("body_entered", self, "grass_walk")
	disconnect("body_exited", self, "grass_walk")
	disconnect("area_entered", self, "cut") # deberìa ser solo la espada.
	grass_walk_node.queue_free()
	$SFX_Cut.playing = false
	$SFX_Cut.playing = true
	$anim.play("leaf_falling")
	yield($SFX_Cut, "finished")
	queue_free()
		