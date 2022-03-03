extends Control

onready var timer := $Timer

var jump_key = "dialogic_next"

var waiting = false


func _input(event):
	if event.is_action_pressed(jump_key) and waiting:
			waiting = false


func _ready():
	hide()


func stop():
	waiting = false
	timer.stop()
	hide()


func start():
	waiting = true
	timer.start()
	show()


func _on_Timer_timeout() -> void:
	if waiting:
		if visible:
			hide()
		else:
			show()
	else:
		stop()
