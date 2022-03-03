extends Control


export(Texture) var texture
export(String) var dilemma_name = ""
export(Array, String) var choices_names = []
export(Array, String, MULTILINE) var choices_descriptions = []


var choice : int = 0 setget set_choice
export(float) var info_panel_height := 500.0

onready var tween = $Tween
onready var hover_control = $HoverControl
onready var container = $VBoxContainer
onready var choice_label = $VBoxContainer/ChoiceLabel
onready var dilemma_label = $VBoxContainer/DilemmaLabel
onready var texture_rect = $VBoxContainer/TextureRect


func _ready():
	container.hide()
	dilemma_label.text = dilemma_name
	choice_label.text = ""
	texture_rect.texture = texture
	hover_control.selection_object = texture_rect
	hover_control.infobox_position = "top"
	hover_control.info_panel.title = ""
	hover_control.info_panel.content = ""
	hover_control.info_panel_height = info_panel_height


func start_anim():
	tween.interpolate_property(container, "rect_scale",  Vector2(0, 0), Vector2(1, 1), 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(container, "rect_position",  Vector2(75, 75), Vector2(0, 0), 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	container.rect_scale = Vector2(0, 0)
	container.rect_position = Vector2(75, 75)
	container.show()
	tween.start()


func _set_description():
	if choice < choices_names.size() and choice < choices_descriptions.size():
		hover_control.info_panel.title = choices_names[choice]
		hover_control.info_panel.content = choices_descriptions[choice]
		choice_label.text = choices_names[choice]
	else:
		hover_control.info_panel.title = ""
		hover_control.info_panel.content = ""
		choice_label.text = ""


func set_choice(new_value: int):
	choice = new_value
	_set_description()
	start_anim()
