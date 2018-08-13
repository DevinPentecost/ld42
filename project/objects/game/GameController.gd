extends Node

signal game_over(time, adoptions)
signal dog_adopted(dog_name)
signal score_changed(time, adoptions)
signal food_changed(food_amount)
signal open_kennels_changed(open_kennel_count, total_kennels)
signal not_enough_food

#Music
export(AudioStream) var bgm

#Scoring
var time = 0
var adoptions = 0

#The player
onready var _player = $"../Player"

#The game grid
onready var _game_grid = $"../GameGrid"

#Food
const MAX_PLAYER_FOOD = 6
var _player_food = MAX_PLAYER_FOOD setget _set_player_food

#Dog spawning
onready var _spawn_timer = $SpawnTimer
const MIN_DOG_SPAWN_TIME = 15
const MAX_DOG_SPAWN_TIME = 25
var _all_kennels = []
var _empty_kennels = []

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	#Randomize RNG
	randomize()
	
	#Get all the kennels
	_initialize_kennels()
	
	#Spawn the first dogs
	call_deferred("_spawn_dog")
	call_deferred("_spawn_dog")
	call_deferred("_spawn_dog")
	call_deferred("_spawn_dog")
	_start_dog_spawn()
	
	#Track every frame
	set_process(true)
	
	#Let the player know when a dog is adopted
	connect("dog_adopted", _player, "_on_GameController_dog_adopted")
	
	#Update the gui
	_update_gui()
	
func _update_gui():
	_update_score()
	emit_signal("food_changed", _player_food, MAX_PLAYER_FOOD)
	emit_signal("open_kennels_changed", _empty_kennels.size(), _all_kennels.size())

func _process(delta):
	#Add to the time alive
	time += delta
	_update_score()
	
func _update_score():
	#GUI should be listening!
	emit_signal("score_changed", time, adoptions)

func _start_dog_spawn():
	#Pick a time
	var spawn_delay = rand_range(MIN_DOG_SPAWN_TIME, MAX_DOG_SPAWN_TIME)
	_spawn_timer.wait_time = spawn_delay
	_spawn_timer.start()

func _initialize_kennels():
	
	#Get all of the kennels
	_all_kennels = get_tree().get_nodes_in_group("kennel")
	for kennel in _all_kennels:
		#It starts empty
		_empty_kennels.append(kennel)
		
		#Listen for adoptions
		kennel.connect("dog_adopted", self, "_on_Kennel_dog_adopted", [kennel])

func _set_player_food(new_food):
	#A good number?
	new_food = max(new_food, 0)
	new_food = min(new_food, MAX_PLAYER_FOOD)
	_player_food = new_food
	
	#Alert whoever is listening
	emit_signal("food_changed", _player_food, MAX_PLAYER_FOOD)
	
func can_player_spend_food():
	#Do we have any?
	return _player_food > 0
	
func spend_player_food(amount=1):
	#Can we feed anything?
	if not can_player_spend_food():
		return null
	
	#Remove food from the player's inventory
	_set_player_food(_player_food - 1)
	
	#Return the amount remaining
	return _player_food
	
func fill_player_food(amount=null):
	#Was an amount specified?
	if amount == null:
		#Always max
		amount = MAX_PLAYER_FOOD
	
	#Set it
	_set_player_food(amount)
	
func player_feed_kennel(kennel_node):
	#A kennel is attempting to feed
	
	#Can we?
	print(_player_food)
	if can_player_spend_food():
		#We spend that food
		var remaining_food = spend_player_food()
		
		#Tell the kennel to be happy or whatever
		kennel_node._active_dog_node.feed()
		kennel_node.play_pour_sound()
		
	else:
		#We need to alert folks that there wasn't enough food
		emit_signal("not_enough_food")

func _on_Kennel_dog_adopted(kennel):
	
	#Give the player a point
	adoptions += 1
	_update_score()
	
	#Send a toast
	emit_signal("dog_adopted", kennel._active_dog_node.dog_name)
	
	#Add it to the list of empty kennels
	_empty_kennels.append(kennel)
	
	#Update kennel count
	emit_signal("open_kennels_changed", _empty_kennels.size(), _all_kennels.size())

func _spawn_dog():
	
	#Are there any available spots?
	var available_kennels = _empty_kennels.size()
	if available_kennels <= 0:
		#Player has lost!
		print("NO ROOM FOR DOGGIES YOU LOST!")
		emit_signal("game_over")
		get_tree().call_group("player", "game_over")
		_spawn_timer.stop()
		return
	
	#Get a kennel and call it occupied
	var kennel_index = randi() % available_kennels
	var target_kennel = _empty_kennels[kennel_index]
	_empty_kennels.remove(kennel_index)
	
	#Tell the kennel to put a dog in it
	target_kennel.spawn_dog()
	
	#Notify the number has changed
	emit_signal("open_kennels_changed", _empty_kennels.size(), _all_kennels.size())
	
func _on_SpawnTimer_timeout():
	
	#Make the dog
	_spawn_dog()
	
	#Spawn another one!
	_start_dog_spawn()

func _on_Kennel_dog_status_changed():
	pass # replace with function body
