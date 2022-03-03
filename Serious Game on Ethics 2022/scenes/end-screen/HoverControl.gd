extends Control

var selection_object: Control
var infobox_position := "left"


var info_panel_height := 200.0 setget set_info_panel_height


onready var hover_tween = $HoverTween
onready var info_panel = $Control/InfoPanel


func _ready():
	info_panel.modulate = Color(1, 1, 1, 0)
	connect("mouse_entered", self, '_on_mouse_entered')
	connect("mouse_exited", self, '_on_mouse_exited')
	hover_tween.connect("tween_completed", self, "_on_HoverTween_tween_completed")
	info_panel.rect_size.y = info_panel_height


func _on_mouse_exited():
	hover_tween.interpolate_property(selection_object, "modulate", null, Color(1, 1, 1, 1), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	hover_tween.interpolate_property(info_panel, "modulate",  null, Color(1, 1, 1, 0), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	hover_tween.start()
	
	
func _on_mouse_entered():
	hover_tween.stop_all()
	if _can_show_info_panel():
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		set_infobox_position()
		info_panel.show()
		hover_tween.interpolate_property(selection_object, "modulate",  null, Color("#615ea4"), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		hover_tween.interpolate_property(info_panel, "modulate",  null, Color(1, 1, 1, 1), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		hover_tween.start()
	else:
		mouse_default_cursor_shape = Control.CURSOR_ARROW


func _can_show_info_panel():
	return not info_panel.content.empty()

func set_infobox_position():
	var s = rect_size
	var info_s = info_panel.rect_size
	var offset = 30
	match infobox_position:
		"top":
			info_panel.rect_position = Vector2((s.x - info_s.x)/2, -(info_s.y + offset))
		"bottom":
			info_panel.rect_position = Vector2((s.x - info_s.x)/2, s.y + offset)
		"left":
			info_panel.rect_position = Vector2(-(info_s.x + offset), (s.y - info_s.y)/2)
		"right":
			info_panel.rect_position = Vector2(s.x + offset, (s.y - info_s.y)/2)


func _on_HoverTween_tween_completed(object: Object, key: NodePath):
	if object == info_panel and info_panel.modulate == Color(1, 1, 1, 0):
		info_panel.hide()


func set_info_panel_height(new_value: float):
	info_panel_height = new_value
	info_panel.rect_size.y = info_panel_height
