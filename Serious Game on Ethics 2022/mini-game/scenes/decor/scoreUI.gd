extends Control

onready var objective_label := $MarginContainer/VBoxContainer/ObjectiveLabel
onready var score_label := $MarginContainer/VBoxContainer/ScoreLabel

var game_mode

var game_objective : int

func update_score(score: int):
	score_label.text = String(score) + "/" + String(game_objective)


func start(initial_score: int):
	update_score(initial_score)
	show()


func init(mode: String, objective: int):
	game_objective = objective
	game_mode = mode
	if game_mode == "score":
		objective_label.text = "Obtenez le score indiqué"
	elif game_mode == "time":
		objective_label.text = "Survivez le temps indiqué"
	else:
		objective_label.text = "Erreur"
	hide()
