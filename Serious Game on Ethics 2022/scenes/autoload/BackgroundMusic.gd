extends Control

onready var _track1 := $Track1
onready var _track2 := $Track2

var fade_in_track: AudioStreamPlayer
var fade_out_track: AudioStreamPlayer

var current_path = ""
var current_volume = 0
var paused_volume_offset = -10

var paused = false

func _ready():
	$Tween.connect("tween_all_completed", self, "on_Tween_tween_all_completed")


func _process(delta):
	if paused and not get_tree().paused:
		set_paused(false)
	elif not paused and get_tree().paused:
		set_paused(true)


func crossfade_to(path: String, volume:float, fade_length: float) -> void:
	if current_path == path:
		return
	
	var stream: AudioStream = load(path)
	fade_out_track = _track1
	fade_in_track = _track2
	
	if _track2.playing:
		fade_out_track = _track2
		fade_in_track = _track1
	
	# setup the new track
	fade_in_track.stream = stream
	fade_in_track.volume_db = -60
	
	
	$Tween.interpolate_property(fade_out_track, "volume_db", null, -60, fade_length, Tween.TRANS_LINEAR)
	$Tween.interpolate_property(fade_in_track, "volume_db", -60, volume, fade_length, Tween.TRANS_LINEAR)
	$Tween.start()
	
	fade_in_track.play()
	current_volume = volume
	current_path = path


func on_Tween_tween_all_completed():
	fade_out_track.stop()


func set_paused(pause: bool):
	paused = pause
	var volume = current_volume
	if pause:
		volume += paused_volume_offset
	
	if _track1.playing:
		_track1.volume_db = volume
	elif _track2.playing:
		_track2.volume_db = volume


func fade_out(fade_length:float = 1) -> void:
	current_path = ""
	$Tween.interpolate_property(_track1, "volume_db", null, -60, fade_length, Tween.TRANS_LINEAR)
	$Tween.interpolate_property(_track2, "volume_db", null, -60, fade_length, Tween.TRANS_LINEAR)
	$Tween.start()
