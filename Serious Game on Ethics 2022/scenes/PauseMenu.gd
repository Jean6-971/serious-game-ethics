extends Control

onready var panel := $MarginContainer/Panel
onready var background := $Background
onready var tween := $Tween

var animation_speed = 0.4

func load_main_menu():
	Transit.change_scene("res://scenes/MainMenu.tscn", 0.5)


func pause():
	if not get_tree().paused:
		get_tree().paused = true
		show()
		tween.stop_all()
		tween.interpolate_property(background, "modulate",  null, Color(1, 1, 1, 1), 2*animation_speed/3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(panel, "modulate",  null, Color(1, 1, 1, 1), animation_speed, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()


func unpause():
	if get_tree().paused:
		get_tree().paused = false
		tween.stop_all()
		tween.interpolate_property(background, "modulate",  null, Color(1, 1, 1, 0), animation_speed/2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(panel, "modulate",  null, Color(1, 1, 1, 0), animation_speed/2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()


func _ready():
	panel.modulate = Color(1, 1, 1, 0)
	background.modulate = Color(1, 1, 1, 0)
	connect("gui_input", self, '_on_gui_input')
	tween.connect("tween_all_completed", self, "_on_Tween_tween_all_completed")


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel") and visible:
		unpause()
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("ui_cancel") and not visible:
		pause()
		get_tree().set_input_as_handled()


func _on_BackgroundButton_pressed():
	unpause()


func _on_ContinueButton_pressed():
	unpause()


func _on_MenuButton_pressed():
	unpause()
	load_main_menu()


func _on_Tween_tween_all_completed():
	if panel.modulate == Color(1, 1, 1, 0):
		hide()
