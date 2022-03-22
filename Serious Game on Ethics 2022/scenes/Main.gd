extends Node

onready var mini_game = $MiniGame;

var dialogic_node;

var STUDENT_MUSIC = "res://music/etudiant.ogg"
var ENGI_MUSIC = "res://music/ingenieur.ogg"
var USER_MUSIC = "res://music/utilisateur.ogg"

func _ready():
	#Dialogic.reset_saves()
	dialogic_node = Dialogic.start_from_save('I_00_start')
	dialogic_node.connect('dialogic_signal', self, "_on_Dialogic_signal_received")
	add_child_below_node(mini_game, dialogic_node)
	play_music()


func play_music():
	var current_phase = Dialogic.get_variable("current_phase")
	var music = STUDENT_MUSIC
	match current_phase:
		"0":
			music = STUDENT_MUSIC
		"1":
			music = ENGI_MUSIC
		"2":
			music = USER_MUSIC
	BackgroundMusic.crossfade_to(music, -10, 1)


func _on_Dialogic_signal_received(value: String):
	var args = value.split(" ")
	if args.size() > 0:
		var type = args[0];
		match type:
			"play_music":
				play_music()
			"start_minigame":
				start_minigame()
			"setup_minigame":
				if (args.size() >= 3):
					setup_minigame(args[1], int(args[2]), args[3], args[4], args[5], int(args[6]))
				else:
					print("not enough arguments for start_minigame")
			"end_game":
				Transit.change_scene("res://scenes/animal/AnimalScene.tscn", 1)
			_:
				print("wrong type")


func setup_minigame(mode: String, goal: int, difficulty: String, next_timeline_lose: String, next_timeline_win: String, version: int):
	mini_game.setup(mode, goal, difficulty, next_timeline_lose, next_timeline_win, version)


func start_minigame():
	mini_game.start()


func _on_MiniGame_game_over(next_timeline: String):
	print("game over received: " + next_timeline)
	dialogic_node = Dialogic.start(next_timeline, false)
	dialogic_node.connect('dialogic_signal', self, "_on_Dialogic_signal_received")
	add_child_below_node(mini_game, dialogic_node)
