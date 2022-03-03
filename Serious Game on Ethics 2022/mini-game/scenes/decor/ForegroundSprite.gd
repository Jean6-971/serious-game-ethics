extends Sprite

export var scroll_speed = 9

export(Array, Texture) var textures := []

var speed_offset : float = 0
var moving = false
var game_version := 0 setget set_game_version

signal viewport_entered(object)
signal viewport_exited(object)


func start():
	moving = true


func stop():
	moving = false


func _physics_process(delta):
	if moving:
		move()


func move():
	position.x -= scroll_speed + speed_offset


func set_game_version(new_value: int):
	game_version = new_value
	if game_version < textures.size():
		texture = textures[game_version]
	else:
		texture = textures[0]


func _on_VisibilityNotifier2D_viewport_entered(viewport: Viewport) -> void:
	emit_signal("viewport_entered", self)


func _on_VisibilityNotifier2D_viewport_exited(viewport: Viewport) -> void:
	emit_signal("viewport_exited", self)
