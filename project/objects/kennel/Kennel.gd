extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var _active = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func on_player_action():
	
	#Is the player here?
	if _active:
		#We respond!
		get_tree().call_group("game_controller", "player_feed_kennel", self)
		print("FEED THAT DOG?!?!")
	
	pass

func _on_ActionArea_body_entered(body):
	#For now, assume it's the player
	_active = true


func _on_ActionArea_body_exited(body):
	#For now, assume it's the player
	_active = false
