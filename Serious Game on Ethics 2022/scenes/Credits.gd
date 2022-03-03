extends Control



func load_main_menu():
	Transit.change_scene("res://scenes/MainMenu.tscn", 0.2)


func _on_BackButton_pressed():
	load_main_menu()
