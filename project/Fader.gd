extends ColorRect

signal fade_completed

var _color = null
const TWEEN_DURATION = 1

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	_color = color

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func fade_in(delay=0):
	#Show it
	visible = true
	
	#Hide it
	color = _color
	color.a = 0
	
	#Show it
	$Tween.interpolate_property(self, "color", color, _color, TWEEN_DURATION, Tween.TRANS_QUAD, Tween.EASE_OUT, delay)
	$Tween.start()
	yield($Tween, "tween_completed")
	emit_signal("fade_completed")
	
func fade_out(delay=0):
	#Show it
	visible = true
	
	#Hide it
	color = _color
	var target_color = _color
	target_color.a = 0
	
	#Show it
	$Tween.interpolate_property(self, "color", color, target_color, TWEEN_DURATION, Tween.TRANS_QUAD, Tween.EASE_OUT, delay)
	$Tween.start()
	yield($Tween, "tween_completed")
	visible = false
	emit_signal("fade_completed")
	
