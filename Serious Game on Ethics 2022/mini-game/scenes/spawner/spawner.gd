extends Node2D

export (Array,PackedScene) var scenes

var random_scene = RandomNumberGenerator.new()
var random_timer = RandomNumberGenerator.new()
var scene_index = 0;
var last_object
var end_of_game = false
var timer_speed : float = 1
var random_threshold = 50
var scenes_offset = 0
var speed_offset : float = 0 setget set_speed_offset

onready var timer := $Timer
onready var items := $items

var last_timer_random : float = 1

func init(difficulty: String, version: int):
	match difficulty:
		"easy":
			timer_speed = 1
			random_threshold = 40
		"hard":
			timer_speed = 0.9
			random_threshold = 25
		_:
			pass
	scenes_offset = version
	update_timer()
	set_speed_offset(0)


func set_speed_offset(new_value: float):
	speed_offset = new_value
	for obj in items.get_children():
		obj.speed_offset = speed_offset


func _on_Timer_timeout():
	random_scene.randomize()
	scene_index = random_scene.randi_range(1,100)
	if(scene_index >= random_threshold):
		scene_index = 1
	else:
		scene_index = 0
	var tmp = scenes[scene_index+scenes_offset*2].instance()
	tmp.speed_offset = speed_offset
	items.add_child(tmp)
	last_object = tmp
	update_timer()


func update_timer():
	random_timer.randomize()
	var random
	if last_timer_random < -0.5:
		random = random_scene.randf_range(-0.4, 1.5)
	else:
		random = random_scene.randf_range(-0.8, 1.5)
	last_timer_random = random
	timer.wait_time = timer_speed + random


func start():
	timer.start()


func stop():
	timer.stop()
	for obj in items.get_children():
		obj.queue_free()
