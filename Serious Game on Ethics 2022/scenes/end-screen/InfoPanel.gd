extends Panel

var title := "" setget set_title
var content := "" setget set_content

onready var title_label = $MarginContainer/VBoxContainer/Title
onready var content_label = $MarginContainer/VBoxContainer/Content

func set_title(new_value: String):
	title = new_value
	title_label.text = title


func set_content(new_value: String):
	content = new_value
	content_label.text = content
