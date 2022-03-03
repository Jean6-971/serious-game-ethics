extends Node2D

var sprite_scene = preload("res://mini-game/scenes/decor/ForegroundSprite.tscn")

var sprites := []
var game_version := 0
var moving := false

var speed_offset : float = 0 setget set_speed_offset

func _ready():
	sprites.append($ForegroundSprite)
	stop()


func init(speed: float, version: int):
	game_version = version
	for s in sprites:
		s.game_version = game_version
	set_speed_offset(speed)


func set_speed_offset(new_value: float):
	speed_offset = new_value
	for t in sprites:
		t.speed_offset = speed_offset


func stop():
	moving = false
	for t in sprites:
		t.stop()


func start():
	moving = true
	for t in sprites:
		t.start()


func _on_ForegroundSprite_viewport_entered(object: Sprite) -> void:
	var new_sprite = sprite_scene.instance()
	new_sprite.position = Vector2(1920, 0)
	new_sprite.speed_offset = speed_offset
	new_sprite.connect("viewport_entered", self, "_on_ForegroundSprite_viewport_entered")
	new_sprite.connect("viewport_exited", self, "_on_ForegroundSprite_viewport_exited")
	if moving:
		new_sprite.start()
	new_sprite.game_version = game_version
	add_child(new_sprite)
	sprites.append(new_sprite)


func _on_ForegroundSprite_viewport_exited(object: Sprite) -> void:
	sprites.remove(sprites.find(object))
	object.queue_free()
