extends "res://util/StatsHandler.gd"

onready var progress_container = $VBoxContainer/Control/RecapContainer/MarginContainer/Panel/MarginContainer/VBoxContainer/MarginContainer/GaugesContainer
onready var choices_container = $VBoxContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2
onready var main_container = $VBoxContainer/Control
onready var main_tween = $VBoxContainer/Control/Tween
onready var recap_container = $VBoxContainer/Control/RecapContainer
onready var characters_container = $VBoxContainer/Control/CharactersContainer
onready var gauges_timer = $GaugesTimer
onready var choices_timer = $ChoicesTimer

var shown_gauge_index = 0
var shown_choice_index = 0

func _ready():
	progress_container.connect("mouse_entered", self, '_on_mouse_entered')
	progress_container.connect("mouse_exited", self, '_on_mouse_exited')
	
	_set_characters_relations()
	
	print(gauges_values)
	print(relations_values)
	print(choices_values)
	
	gauges_timer.start()
	# Do not wait to show the first choice
	_on_ChoicesTimer_timeout()
	choices_timer.start()
	
	_play_start_animation()



func _play_start_animation():
	main_tween.interpolate_property(recap_container, "rect_position", Vector2(0, recap_container.rect_size.y/3), Vector2(0, 0), 0.8, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	main_tween.interpolate_property(recap_container, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.8, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	
	_setup_character_animation(characters_container.get_child(0), true)
	_setup_character_animation(characters_container.get_child(2), false)
	main_tween.start()


func _setup_character_animation(character: Control, is_left: bool):
	var delay = 0.3 if is_left else 0.5
	var x_pos = character.rect_position.x - character.rect_size.x/3 if is_left else character.rect_position.x + character.rect_size.x/3
	character.modulate = Color(1, 1, 1, 0)
	main_tween.interpolate_property(character, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.8, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, delay)
	main_tween.interpolate_property(character, "rect_position", Vector2(x_pos, character.rect_position.y), character.rect_position, 0.8, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, delay)
	


func _on_mouse_exited():
	main_container.move_child(recap_container, 0)


func _on_mouse_entered():
	# Make sure the recap is behind the characters
	# This allows showing the infobox above the recap
	main_container.move_child(recap_container, 1)


func _set_characters_relations():
	for i in range(0, relations_values.size()):
		var child_index = i
		# take the spacer into account
		if i >= 1:
			child_index += 1
		characters_container.get_child(child_index).relation = relations_values[i]


func _on_GaugesTimer_timeout() -> void:
	var c = progress_container.get_child(shown_gauge_index)
	c.progress = gauges_values[shown_gauge_index]
	shown_gauge_index += 1
	if shown_gauge_index >= progress_container.get_child_count():
		gauges_timer.stop()


func _on_ChoicesTimer_timeout() -> void:
	# take spacers into account
	var c = choices_container.get_child(shown_choice_index * 2)
	if shown_choice_index < choices_values.size():
		c.choice = int(choices_values[shown_choice_index])
		shown_choice_index += 1
		if shown_choice_index >= choices_container.get_child_count():
			choices_timer.stop()
	else:
		choices_timer.stop()


func _on_ExitButton_pressed():
	Transit.change_scene("res://scenes/MainMenu.tscn", 0.5)


