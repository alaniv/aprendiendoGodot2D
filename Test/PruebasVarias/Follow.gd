extends Node2D


func _ready():
	$Node2D/Impa.is_possessed = true
	$Node2D/Impa.npc_follow($Node2D/Link, self.position)
