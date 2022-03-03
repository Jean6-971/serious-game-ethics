extends Control

export(bool) var is_left := true
export(float) var info_panel_height := 300.0
export(String) var title := ""
export(Texture) var texture_bad
export(Texture) var texture_neutral
export(Texture) var texture_good

export(String, MULTILINE) var description_bad: = ""
export(String, MULTILINE) var description_neutral := ""
export(String, MULTILINE) var description_good := ""


var DESCRIPTION_THRESHOLDS = [40, 60]
var relation : float = 0 setget set_relation


onready var texture_rect = $TextureRect
onready var hover_control = $HoverControl


func _ready():
	texture_rect.texture = texture_neutral
	hover_control.selection_object = texture_rect
	if is_left:
		hover_control.infobox_position = "right"
	else:
		hover_control.infobox_position = "left"
	hover_control.info_panel.title = title
	hover_control.info_panel.content = ""
	hover_control.info_panel_height = info_panel_height


func _set_description():
	if relation < DESCRIPTION_THRESHOLDS[0]:
		hover_control.info_panel.content = description_bad
		texture_rect.texture = texture_bad
	elif relation > DESCRIPTION_THRESHOLDS[1]:
		hover_control.info_panel.content = description_good
		texture_rect.texture = texture_good
	else:
		hover_control.info_panel.content = description_neutral
		texture_rect.texture = texture_neutral


func set_relation(new_value: float):
	relation = new_value
	_set_description()
