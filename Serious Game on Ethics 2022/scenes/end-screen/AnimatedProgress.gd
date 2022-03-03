extends ProgressBar


onready var tween = $Tween


func _ready():
	tween.interpolate_property(self, "value", 0, 100, 1.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()

