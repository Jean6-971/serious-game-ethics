extends Control


onready var label : Label = $MarginContainer/Label

func _ready():
	hide()


func update_timer(score: int):
	if score > 0:
		label.text = String(score)
	else:
		label.text = "GO !"


func init():
	update_timer(3)
	show()

