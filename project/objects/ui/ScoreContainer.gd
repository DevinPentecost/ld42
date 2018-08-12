extends VBoxContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func set_score(time, adoptions):
	
	#Set the time
	var seconds = int(time) % 60
	var minutes = int(time/60)
	var time_text = "%02d:%02d" % [minutes, seconds]
	$TimeContainer/TimeNumber.text = time_text
	
	#Set the rescues
	$RescueContainer/ScoreNumber.text = str(adoptions)