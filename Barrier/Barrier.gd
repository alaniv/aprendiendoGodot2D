extends StaticBody2D

signal barrier_triggered

func barrier_notify():
	emit_signal("barrier_triggered")
