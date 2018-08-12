extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const TOAST_VERTICAL_DISTANCE = 50
const TOAST_HORIZONTAL_DISTANCE = 150
const TOAST_TIME = 1
const TOAST_HOLD = 2

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func toast(toast_text):
	#Create a new label
	var label = Label.new()
	var tween = Tween.new()
	var timer = Timer.new()
	add_child(label)
	label.add_child(tween)
	label.add_child(timer)
	
	#Give it a background
	var background = ColorRect.new()
	background.color = Color(0, 0, 0, 0.25)
	background.set_anchor_and_margin(MARGIN_TOP, 0, -2)
	background.set_anchor_and_margin(MARGIN_LEFT, 0, -2)
	background.set_anchor_and_margin(MARGIN_BOTTOM, 1, 2)
	background.set_anchor_and_margin(MARGIN_RIGHT, 1, 2)
	label.add_child(background)
	
	#Give it the text
	label.text = toast_text
	
	#Coloring
	var color = Color(1, 1, 1, 1)
	var hidden = Color(1, 1, 1, 0)
	
	#Set some tweens
	var start_position = Vector2(0, TOAST_VERTICAL_DISTANCE)
	var end_position = Vector2(0, -TOAST_VERTICAL_DISTANCE)
	tween.interpolate_property(label, "modulate", hidden, color, TOAST_TIME, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(label, "rect_position", start_position, end_position, TOAST_TIME, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	
	#Make the timer go
	timer.wait_time = TOAST_HOLD
	timer.one_shot = true
	timer.start()
	yield(timer, "timeout")
	
	#Now tween it away
	start_position = label.rect_position
	end_position = label.rect_position + Vector2(TOAST_HORIZONTAL_DISTANCE, 0)
	tween.interpolate_property(label, "modulate", color, hidden, TOAST_TIME, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(label, "rect_position", start_position, end_position, TOAST_TIME, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	
	#Now kill them
	label.queue_free()
	
	