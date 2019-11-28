extends Control

export (bool) var twoDigits = false
onready var dig1 = $"1"
onready var dig2 = $"2"
onready var dig3 = $"3"

#func _ready():
#	set_number(321)
	
func set_number(num): # expected value 0-999
	if twoDigits:
		dig1.hide()
	var num3 = num % 10
	var num2 = num % 100 - num3
	var num1 = num - num2 - num3
	num2 = int(num2 / 10)
	num1 = int(num1 / 100)
	dig1.frame = num1
	dig2.frame = num2
	dig3.frame = num3
	