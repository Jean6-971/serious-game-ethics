extends Node

signal game_over

onready var foreground := $foreground
onready var background := $background
onready var spawner := $spawner
onready var player := $player
onready var scoreUI := $scoreUI
onready var start_timer_UI := $startTimerUI
onready var instructionsUI := $instructionsUI
onready var score_timer := $ScoreTimer
onready var speed_timer := $SpeedTimer

var next_timeline_lose := ""
var next_timeline_win := ""

var game_mode = ""
var game_goal = 10
var current_goal = 0
var game_difficulty = "easy"
var game_version = 0

var MUSIC = "res://music/mini_jeu.ogg"

var game_speed = 0 setget set_game_speed

export var speed_increments := 0.1
export var max_speed := 8

func _ready():
	pass


func setup(mode: String, goal: int, difficulty: String, next_lose: String, next_win: String, version: int):
	game_goal = goal
	current_goal = 0
	if(difficulty == "hard"):
		game_difficulty = "hard"
	else:
		game_difficulty = "easy"
	game_version = version
	print("setup minigame: " + mode + " " + next_lose + " " + next_win + " | version: " + String(version))
	set_mode(mode)
	background.init(game_version)
	foreground.init(game_speed, game_version)
	spawner.init(game_difficulty, game_version)
	scoreUI.init(mode, goal)
	next_timeline_lose = next_lose
	next_timeline_win = next_win


func set_mode(mode: String):
	match mode:
		"score":
			game_mode = "score"
		"time":
			game_mode = "time"
		_:
			print("unkonwn mini-game mode")
	

func start():
	print("starting minigame")
	BackgroundMusic.crossfade_to(MUSIC, -10, 1)
	start_timer_UI.init()
	var t = Timer.new()
	t.wait_time = 0.5
	t.autostart = true
	add_child(t)
	for n in range(3,0,-1):
		start_timer_UI.update_timer(n)
		yield(t, "timeout")
	start_timer_UI.update_timer(0)
	instructionsUI.start()
	foreground.start()
	player.start()
	yield(t, "timeout")
	yield(t, "timeout")
	start_timer_UI.hide()
	spawner.start()
	if game_mode == "score":
		scoreUI.start(0)
	else:
		scoreUI.start(game_goal)
	t.queue_free()
	if game_mode == "time":
		score_timer.start()
	speed_timer.start()


func stop():
	foreground.stop()
	instructionsUI.stop()
	player.stop()
	spawner.stop()
	score_timer.stop()
	speed_timer.stop()


func on_win():
	stop()
	emit_signal("game_over", next_timeline_win)


func on_game_over():
	stop()
	emit_signal("game_over", next_timeline_lose)


func _on_player_die() -> void:
	on_game_over()


func _on_player_hit() -> void:
	pass


func update_score():
	current_goal += 1
	scoreUI.update_score(current_goal)
	if current_goal >= game_goal:
		on_win()


func set_game_speed(new_value: float):
	game_speed = new_value
	if game_speed > max_speed:
		game_speed = max_speed
	foreground.speed_offset = game_speed
	spawner.speed_offset = game_speed


func _on_player_score() -> void:
	update_score()


func _on_ScoreTimer_timeout() -> void:
	update_score()


func _on_SpeedTimer_timeout() -> void:
	set_game_speed(game_speed + speed_increments)
