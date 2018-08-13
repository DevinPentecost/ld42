extends HBoxContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#Colors
const safe_color = Color(0.09, 0.06, 0.16)
export(Color) var warning_color = Color(0.73, 0.71, 0.35)
export(Color) var danger_color = Color(0.91, 0.57, 0.34)
export(Color) var out_color = Color(1, 0.33, 0.47)

#How many kennels left till we get worried
const KENNEL_COUNT_WARNING = 10
const KENNEL_COUNT_DANGER = 4

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
	var toast = null
	var text_color = safe_color
	if current_food == 0:
		text_color = out_color
		toast = "You're out of food! Get some more!"
	elif current_food < FOOD_COUNT_DANGER:
		text_color = danger_color
		toast = "Almost out of food!"
	elif current_food < FOOD_COUNT_WARNING:
		text_color = warning_color
		toast = "Running low on food..."
	
	#Alert the player?
	if toast:
		get_tree().call_group("gui", "_emit_toast", toast)
	
	#Update the label
	$FoodContainer/FoodAmount.text = food_text
	$FoodContainer/FoodAmount.modulate = text_color
	$FoodContainer/FoodLabel.modulate = text_color
	
	#Do shaking or something?
	
func update_kennels(current_kennels, total_kennels):
	
	#How many kennels remaining?
	var kennel_text = "%02d/%02d" % [current_kennels, total_kennels]
	var toast = null
	var text_color = safe_color
	if current_kennels == 0:
		text_color = out_color
		toast = "Out of kennels! One more dog and it's over..."
	elif current_kennels < KENNEL_COUNT_DANGER:
		text_color = danger_color
		toast = "Almost out of kennels, get to work!"
	elif current_kennels < KENNEL_COUNT_WARNING:
		text_color = warning_color
		toast = "Running low on empty kennels..."
	
	#Alert the player?
	if toast:
		get_tree().call_group("gui", "_emit_toast", toast)
	
	#Update the label
	$KennelContainer/KennelAmount.text = kennel_text
	$KennelContainer/KennelAmount.modulate = text_color
	$KennelContainer/KennelLabel.modulate = text_color