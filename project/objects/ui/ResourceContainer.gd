extends VBoxContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#Colors
export(Color) var safe_color = Color(1, 1, 1, 1)
export(Color) var warning_color
export(Color) var danger_color
export(Color) var out_color = Color(1, 0, 0, 1)

#How many kennels left till we get worried
const KENNEL_COUNT_WARNING = 7
const KENNEL_COUNT_DANGER = 2

#How much food to worry about
const FOOD_COUNT_WARNING = 5
const FOOD_COUNT_DANGER = 3

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func update_food(current_food, max_food):
	
	#How much food is remaining?
	var food_text = "%02d/%02d" % [current_food, max_food]
	var text_color = safe_color
	if current_food == 0:
		text_color = out_color
	elif current_food < FOOD_COUNT_DANGER:
		text_color = danger_color
	elif current_food < FOOD_COUNT_WARNING:
		text_color = warning_color
	
	#Update the label
	$FoodContainer/FoodAmount.text = food_text
	$FoodContainer/FoodAmount.modulate = text_color
	
	#Do shaking or something?
	
func update_kennels(current_kennels, total_kennels):
	
	#How many kennels remaining?
	var kennel_text = "%02d/%02d" % [current_kennels, total_kennels]
	var text_color = safe_color
	if current_kennels == 0:
		text_color = out_color
	elif current_kennels < KENNEL_COUNT_DANGER:
		text_color = danger_color
	elif current_kennels < KENNEL_COUNT_WARNING:
		text_color = warning_color
	
	#Update the label
	$KennelContainer/KennelAmount.text = kennel_text
	$KennelContainer/KennelAmount.modulate = text_color