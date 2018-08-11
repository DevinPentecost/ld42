extends Node

signal game_over(time, adoptions)
signal score_changed(time, adoptions)
signal food_changed(food_amount)

#Scoring
var time = 0
var adoptions = 0

#The game grid
onready var _game_grid = $"../GameGrid"

#Food
const MAX_PLAYER_FOOD = 10
var player_food = MAX_PLAYER_FOOD setget _set_player_food

#Dog spawning
onready var _spawn_timer = $SpawnTimer
const MIN_DOG_SPAWN_TIME = 10
const MAX_DOG_SPAWN_TIME = 15
var _all_kennels = []
var _empty_kennels = []

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	#Get all the kennels
	_initialize_kennels()
	
	#Spawn the first dog
	_start_dog_spawn()
	
	#Track every frame
	set_process(true)
	

func _process(delta):
	#Add to the time alive
	time += delta
	_update_score()
	
func _update_score():
	emit_signal("score_changed", time, adoptions)

func _start_dog_spawn():
	#Pick a time
	var spawn_delay = rand_range(MIN_DOG_SPAWN_TIME, MAX_DOG_SPAWN_TIME)
	_spawn_timer.wait_time = spawn_delay
	_spawn_timer.start()

func _initialize_kennels():
	
	#Get all of the kennels
	var all_kennels = _game_grid.get_all_kennels()
	for kennel in all_kennels:
		#It starts empty
		_empty_kennels.append(kennel)
		
		#Listen for adoptions
		kennel.connect("dog_adopted", self, "_on_Kennel_dog_adopted", kennel)

func _set_player_food(new_food):
	#A good number?
	new_food = max(new_food, 0)
	new_food = min(new_food, MAX_PLAYER_FOOD)
	player_food = new_food
	
func can_player_spend_food():
	#Do we have any?
	return player_food > 0
	
func spend_player_food(amount=1):
	#Can we feed anything?
	if not can_player_spend_food():
		return null
	
	#Remove food from the player's inventory
	player_food -= 1
	return player_food
	
func fill_player_food(amount=null):
	#Was an amount specified?
	if amount == null:
		#Always max
		amount = MAX_PLAYER_FOOD
	
	#Set it
	_set_player_food(amount)

func on_Kennel_dog_adopted(kennel):
	
	#Give the player a point
	adoptions += 1
	_update_score()
	
	#Add it to the list of empty kennels
	_empty_kennels.append(kennel)

func _spawn_dog():
	
	#Are there any available spots?
	var available_kennels = _empty_kennels.size()
	if available_kennels <= 0:
		#Player has lost!
		emit_signal("game_over")
		get_tree().call_group("player", "game_over")
		_spawn_timer.stop()
	
	#Get a kennel and call it occupied
	var kennel_index = randi() % available_kennels
	var target_kennel = _empty_kennels[kennel_index]
	_empty_kennels.remove(kennel_index)
	
	#Tell the kennel to put a dog in it
	target_kennel.spawn_dog()
	

func _on_SpawnTimer_timeout():
	
	#Make the dog
	_spawn_dog()
	
	#Spawn another one!
	_start_dog_spawn()