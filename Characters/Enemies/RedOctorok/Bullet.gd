extends KinematicBody2D

var speed = 150
var direction = Vector2(1,0)
var attack_damage = 0.25

#TODO agregar animacion. cambiar queue_free por 1 pool...

func _ready():
	$VisibilityNotifier2D.connect("viewport_exited", self, "_on_viewport_exit")

func _process(delta):
	var collision_info = move_and_collide(direction * delta * speed)
	var is_player = false
	if collision_info:
		is_player = collision_info.collider.is_in_group("Player")
		queue_free() # reemplazar por animation...
	if is_player:
		get_tree().get_root().get_node("Test/Link").collision_handler(self)

func _on_viewport_exit(x):
	queue_free()