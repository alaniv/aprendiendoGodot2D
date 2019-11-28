extends Node2D

export (bool) var up
export (bool) var down
export (bool) var left
export (bool) var right

signal go_to(direction)

func _ready():
	var timer = Timer.new()
	timer.set_wait_time( 0.5 )
	timer.one_shot = true
	timer.connect("timeout",self,"connect_colliders") 
	add_child(timer) #to process
	timer.start() #to start
	
func connect_colliders():
	if right:
		$Right.connect("body_entered", self, "_on_body_entered", [Vector2(1,0)])
	if left:
		$Left.connect("body_entered", self, "_on_body_entered", [Vector2(-1,0)])
	if up:
		$Up.connect("body_entered", self, "_on_body_entered", [Vector2(0,1)])
	if down:
		$Down.connect("body_entered", self, "_on_body_entered", [Vector2(0,-1)])

func _on_body_entered(body, direction):
	emit_signal("go_to", direction)
	print(self.name)
	print(direction)