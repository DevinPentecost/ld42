extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#Game controller in charge
onready var _game_controller = $"../GameController"
onready var _player = $"../Player"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	#Listen to the game controller
	_game_controller.connect("game_over", self, "_on_GameController_game_over")
	_game_controller.connect("score_changed", self, "_on_GameController_score_changed")
	_game_controller.connect("food_changed", self, "_on_GameController_food_changed")
	_game_controller.connect("not_enough_food", self, "_on_GameController_not_enough_food")
	_game_controller.connect("dog_adopted", self, "_on_GameController_dog_adopted")
	_game_controller.connect("open_kennels_changed", self, "_on_GameController_open_kennels_changed")
	
	#Listen to the player
	_player.connect("near_kennel", self, "_on_Player_near_kennel")
	_player.connect("leave_kennel", self, "_on_Player_leave_kennel")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_GameController_score_changed(time, adoptions):
	
	#Update the score container
	$ScoreContainer.set_score(time, adoptions)
	
func _on_GameController_food_changed(current_food, max_food):
	
	#Update the resource container
	$ResourceContainer.update_food(current_food, max_food)
	
func _on_GameController_not_enough_food():
	
	#Shake the resource container or something
	
	pass
	
func _on_GameController_dog_adopted(dog_name):

	#Let the toast know!
	var toast_string = "%s was adopted!" % dog_name
	$AdoptionToast.toast(toast_string)

func _on_GameController_open_kennels_changed(open_kennel_count, total_kennel_count):
	#Just pass on to the widget
	$ResourceContainer.update_kennels(open_kennel_count, total_kennel_count)

func _on_Player_near_kennel(kennel):
	#Listen for changes
	kennel.connect("dog_status_changed", self, "_on_Kennel_dog_status_changed", [kennel])
	$BioContainer.show()
	$BioContainer.update_dog(kennel._active_dog_node)
	
func _on_Player_leave_kennel(kennel):
	#Done with this doggo
	$BioContainer.hide()
	kennel.disconnect("dog_status_changed", self, "_on_Kennel_dog_status_changed")
	kennel = null
	
func _on_Kennel_dog_status_changed(kennel):
	#Update the bio
	$BioContainer.update_dog(kennel._active_dog_node)