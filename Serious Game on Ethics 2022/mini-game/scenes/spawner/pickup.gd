extends Node2D

export var sprite_texture : Texture
export var type := "bonus" setget , get_type
export var scroll_speed = 9
var speed_offset : float = 0

onready var sprite = $Sprite
onready var audio_stream = $AudioStreamPlayer
onready var timer = $Timer

var malus_sound = preload("res://mini-game/ressources/sounds/error_006.wav")
var bonus_sound = preload("res://mini-game/ressources/sounds/select_006.wav")

var picked_up := false


func _ready():
	sprite.texture = sprite_texture


func _on_notifier_screen_exited() -> void:
	if not picked_up:
		queue_free()


func _physics_process(delta):
	move()


func get_type():
	return type


func move():
	self.position.x -= scroll_speed + speed_offset


func pickup():
	picked_up = true
	timer.start()
	sprite.hide()
	if type == "bonus":
		audio_stream.stream = bonus_sound
	elif type == "malus":
		audio_stream.stream = malus_sound
	audio_stream.play()


func _on_Area2D_body_entered(body: Node) -> void:
	if body.has_method("bonus") and body.has_method("hit"):
		pickup()
		if type == "bonus":
			body.bonus()
		elif type == "malus":
			body.hit()


func _on_AudioStreamPlayer_finished() -> void:
	queue_free()
