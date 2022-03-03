extends KinematicBody2D

var speed = Vector2.ZERO

export var jump_speed = 1100.0
export var gravity = 60.0
export var jump_time = 0.2
export var max_lives = 1

enum {
	RUN,
	JUMP,
	IDLE
}

enum {
	SCORE,
	TIME
}

var jump_key = "dialogic_next"

var player_enabled = false

var state = RUN
var au_sol = true

var current_lives = max_lives
var pressing_jump = false

onready var animation := $AnimatedSprite
onready var bonus_texture := $BonusControl/Sprite
onready var bonus_tween := $BonusControl/Tween
onready var bonus_timer := $BonusControl/Timer
onready var jump_timer := $JumpTimer
onready var jump_stream := $AudioStreamPlayer

signal hit()
signal die()
signal score()

func _ready():
	jump_timer.wait_time = jump_time
	stop()


func _physics_process(delta):
	if player_enabled:
		match state:
			RUN:
				animation.play("man_run")
			JUMP:
				speed = Vector2.ZERO
				speed.y -= jump_speed
				animation.play("man_jump")
				if not pressing_jump:
					state = IDLE
			IDLE:
				pass
		speed.y += gravity
		move_and_collide(speed*delta)


func _input(event: InputEvent):
	if player_enabled and state == RUN and event.is_action_pressed(jump_key):
			jump_timer.start()
			jump_stream.play()
			pressing_jump = true
			state = JUMP
	elif event.is_action_released(jump_key):
		jump_timer.stop()
		pressing_jump = false


func _on_Area2D_body_entered(body):
	if body is StaticBody2D:
		state = RUN


func _on_Area2D_body_exited(body):
	if body is StaticBody2D:
		state = JUMP


func start():
	show()
	player_enabled = true


func stop():
	hide()
	bonus_texture.modulate = Color(1, 1, 1, 0)
	player_enabled = false


func hit():
	current_lives -= 1
	if current_lives > 0:
		emit_signal("hit")
	else:
		current_lives = 0
		emit_signal("die")


func play_bonus_anim():
	bonus_texture.show()
	bonus_tween.stop_all()
	bonus_timer.stop()
	bonus_tween.interpolate_property(bonus_texture, "modulate", null, Color(1, 1, 1, 1), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	bonus_tween.interpolate_property(bonus_texture, "position", Vector2(bonus_texture.position.x, 0), Vector2(bonus_texture.position.x, bonus_texture.position.y), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	bonus_tween.start()
	bonus_timer.start()


func bonus():
	play_bonus_anim()
	emit_signal("score")


func _on_Timer_timeout() -> void:
	bonus_tween.stop_all()
	bonus_tween.interpolate_property(bonus_texture, "modulate", null, Color(1, 1, 1, 0), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	bonus_tween.start()


func _on_JumpTimer_timeout() -> void:
		pressing_jump = false
