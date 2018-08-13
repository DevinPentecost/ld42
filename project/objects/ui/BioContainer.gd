extends VBoxContainer

onready var _tween = $Tween
const TWEEN_DURATION = 0.25
const HIDE_DISTANCE = 15 + 512
var _start_position = null

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	#Grab the starting position
	_start_position = rect_position
	hide(true)
	
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func update_dog(dog_node):
	#Was a dog passed?
	if not dog_node:
		hide(true)
		#_show_empty_kennel()
		return
		
	#Update information about the dog
	$NameContainer/DogName.text = dog_node.dog_name
	$StatsContainer/VBoxContainer/HappinessProgress.value = dog_node.happiness
	$StatsContainer/VBoxContainer/AdoptabilityProgress.value = dog_node.adoption
	$DescriptionContainer/VBoxContainer/Description.text = dog_node.description
	
func _show_empty_kennel():
	#Some dummy info
	$NameContainer/DogName.text = "Empty Kennel"
	$StatsContainer/VBoxContainer/HappinessProgress.value = 0
	$StatsContainer/VBoxContainer/AdoptabilityProgress.value = 0
	$DescriptionContainer/VBoxContainer/Description.text = "No dog here... yet!"

func _tween_to_position(target_position, duration, delay=0):
	#Stop the tween
	_tween.stop_all()
	
	#Make a new tween
	_tween.interpolate_property(self, "rect_position", rect_position, target_position, duration, Tween.TRANS_QUAD, Tween.EASE_OUT, delay)
	
	#Fire off
	_tween.start()
	

func show():
	
	#Go back to the start position
	var target_position = _start_position
	_tween_to_position(target_position, TWEEN_DURATION)
	
	
func hide(instant=false):
	
	#Instant hide?
	var duration = TWEEN_DURATION
	if instant:
		duration = 0.001
	
	#Set the desired location
	var target_position = _start_position
	target_position.x += HIDE_DISTANCE
	_tween_to_position(target_position, duration)