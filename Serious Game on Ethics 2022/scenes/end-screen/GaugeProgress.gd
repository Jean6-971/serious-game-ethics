extends MarginContainer

export(String) var gauge_name := ""
export(Color) var gauge_color := Color.white

export(String, MULTILINE) var description_bad: = ""
export(String, MULTILINE) var description_neutral := ""
export(String, MULTILINE) var description_good := ""


var DESCRIPTION_THRESHOLDS = [40, 60]

var progress : float = 0 setget set_progress

onready var tween = $Tween
onready var hover_control = $HoverControl
onready var container = $VBoxContainer
onready var progress_bar = $VBoxContainer/ProgressBar
onready var label = $VBoxContainer/Label


func _ready():
	container.hide()
	hover_control.selection_object = progress_bar
	hover_control.infobox_position = "left"
	hover_control.info_panel.title = gauge_name
	hover_control.info_panel.content = ""
	label.text = gauge_name
	progress_bar.tint_progress = gauge_color
	container.modulate = Color(1, 1, 1, 0)


func start_anim():
	tween.start()
	container.show()


func _set_description():
	if progress < DESCRIPTION_THRESHOLDS[0]:
		hover_control.info_panel.content = description_bad
	elif progress > DESCRIPTION_THRESHOLDS[1]:
		hover_control.info_panel.content = description_good
	else:
		hover_control.info_panel.content = description_neutral


func set_progress(new_value: float):
	progress = new_value
	_set_description()
#	hover_control.info_panel.content = variable_descriptions[]
	tween.interpolate_property(progress_bar, "value", 0, progress, 1.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(container, "modulate",  Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	start_anim()
