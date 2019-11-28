extends Camera2D

onready var GameManager = $".."
onready var tween = $Tween

signal cam_done

var map_size = Vector2(160,144)
var core_position = Vector2(0,0)

func _process(delta):
	self.position.x = core_position.x + clamp(GameManager.link.position.x - core_position.x - 160/2, 0, map_size.x - 160)
	self.position.y = core_position.y + clamp(GameManager.link.position.y - core_position.y - 144/2, 0, map_size.y - 144)

func movecam(direction):
	set_process(false)
	update_sizes()
	# var vc = Vector2(160 * direction.x, -128 * direction.y)
	core_position += Vector2(map_size.x * direction.x, -(map_size.y - 16) * direction.y)
	var vc = Vector2(160 * direction.x, -128 * direction.y)
	var vc2 = Vector2(12 * direction.x, -16 * direction.y)
	tween.interpolate_property(self, "position",
	                position, position + vc, 0.78, # 1 antes
	                Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	GameManager.link.tween_position(vc2, 0.78, Tween.TRANS_LINEAR)
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("cam_done")
	set_process(true)

func set_camera(direction):
	set_process(false)
	core_position = Vector2(0,0)
	map_size = GameManager.get_node("MapController").world_area_map_size()
	position = direction
	set_process(true)
	
func update_sizes():
	map_size = GameManager.get_node("MapController").world_area_map_size()