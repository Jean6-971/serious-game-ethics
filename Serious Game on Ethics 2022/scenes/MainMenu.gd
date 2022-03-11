extends Control

var MAIN_MENU_MUSIC = "res://music/menu_principal.ogg"

onready var exit_button = $MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/Panel/MarginContainer/CenterContainer/VBoxContainer/MarginContainer2/ExitButton
onready var continue_button = $MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/Panel/MarginContainer/CenterContainer/VBoxContainer/ContinueButton

var save_available := false

func _ready():
	BackgroundMusic.crossfade_to(MAIN_MENU_MUSIC, -10, 1)
	if OS.get_name() == "HTML5":
		exit_button.hide()
	save_available = not Dialogic.get_current_timeline().empty()
	if not save_available:
		continue_button.hide()


func load_main_game():
	Transit.change_scene("res://scenes/Main.tscn", 0.5)


func load_credits():
	Transit.change_scene("res://scenes/Credits.tscn", 0.2)
	
func load_second_chapter():
	Transit.change_scene("res://scenes/MainChapter2.tscn", 0.5)


func _on_NewGameButton_pressed():
	Dialogic.reset_saves()
	load_main_game()
	

func _on_ContinueButton_pressed():
	load_main_game()


func _on_ExitButton_pressed():
	Transit.change_scene("res://scenes/ExitScene.tscn", 0.2)


func _on_CreditsButton_pressed():
	load_credits()


func _on_SecondChapter_pressed():
	Dialogic.set_current_timeline('II_0_0_start_second_chapter')
	load_second_chapter()
	
