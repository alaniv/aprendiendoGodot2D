extends Sprite

# Expected: Sprite with 4 frames 16x16 horizontally aligned

var current_dir = "s"

func _ready():
	$w.connect("body_entered", self, "enter_dir", ["w"])
	$e.connect("body_entered", self, "enter_dir", ["e"])
	$n.connect("body_entered", self, "enter_dir", ["n"])
	$s.connect("body_entered", self, "enter_dir", ["s"])
	$full.connect("body_exited", self, "exit_dir")
	$Timer.connect("timeout", self, "alternate_sprite")
	
func alternate_sprite():
	match current_dir:
		"w":
			self.frame = 1 if (self.frame == 2) else 2
		"e":
			self.frame = 1 if (self.frame == 2) else 2
		"n":
			self.flip_h = not self.flip_h
		"s":
			self.flip_h = not self.flip_h

	
func enter_dir(body, dir):
	current_dir = dir
	match dir:
		"w":
			self.flip_h = true
			self.frame = 1
		"e":
			self.flip_h = false
			self.frame = 1
		"n":
			self.frame = 3
		"s":
			self.frame = 0
		
func exit_dir(body):
	self.flip_h = false
	current_dir = "s"
	self.frame = 0