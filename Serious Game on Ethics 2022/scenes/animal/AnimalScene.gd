extends "res://util/StatsHandler.gd"


onready var text_container = $MarginContainer
onready var animal_container = $CenterContainer
onready var animal_texture = $CenterContainer/AnimalTexture
onready var animal_name = $MarginContainer/CenterContainer/Panel/MarginContainer/VBoxContainer/Title
onready var animal_description = $MarginContainer/CenterContainer/Panel/MarginContainer/VBoxContainer/Content
onready var tween = $Tween

var animation_played := false


export(Array, Texture) var animals := []
export(Array, String) var names := []
export(Array, String, MULTILINE) var descriptions := []


var max_gauge : String


func _ready() -> void:
	var max_gauge = gauges_values.find(gauges_values.max())
	if max_gauge < animals.size() and max_gauge < names.size() and max_gauge < descriptions.size():
		animal_texture.texture = animals[max_gauge]
		animal_name.text = names[max_gauge]
		animal_description.text = descriptions[max_gauge]
	BackgroundMusic.crossfade_to("res://music/menu_principal.ogg", -10, 1)


func play_start_animation():
		tween.interpolate_property(text_container, "rect_position", null, Vector2(0, 0), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(animal_container, "rect_position", null, Vector2(0, -100), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(animal_texture, "rect_scale", null, Vector2(0.8, 0.8), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dialogic_next"):
		if not animation_played:
			animation_played = true
			play_start_animation()
		else:
			Transit.change_scene("res://scenes/end-screen/EndRecap.tscn", 2)

