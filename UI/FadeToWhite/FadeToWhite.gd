extends CanvasLayer

func play(speed):
	$AnimationPlayer.play("Fade", -1, speed, false)

func play_reverse(speed):
	$AnimationPlayer.play("Fade_Reverse", -1, speed, false)

func blink():
	$AnimationPlayer.play("Blink")