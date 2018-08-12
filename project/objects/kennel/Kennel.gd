extends Spatial

signal dog_adopted
signal dog_status_changed

export(PackedScene) var _dog_scene
export(bool) var _force_dog_spawn = false #DEBUG ONLY!

var _active_dog_node = null
var _active = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	#Start with a dog?
	if _force_dog_spawn:
		spawn_dog()
		_active_dog_node._debugging = true
	_update_decor(_force_dog_spawn)
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func spawn_dog():
	
	#Make the dog node
	var new_dog_node = _dog_scene.instance()
	_active_dog_node = new_dog_node
	new_dog_node.connect("adopted", self, "_on_Dog_adopted")
	
	#Get a random name and description
	new_dog_node.dog_name = "Dog #" + str(randi() % 1000)
	new_dog_node.description = "This dog will be put down unless Erin wires up descriptions"
	
	#Pick starting values
	new_dog_node.tend_rate = rand_range(new_dog_node.TEND_RATE_RANGE.x, new_dog_node.TEND_RATE_RANGE.y)
	new_dog_node.adoption_rate = rand_range(new_dog_node.ADOPTION_RATE_RANGE.x, new_dog_node.ADOPTION_RATE_RANGE.y)
	
	#Get a random texture
	var target_texture = null
	match(randi() % 3):
		0:
			target_texture = new_dog_node.TEXTURE_A
		1:
			target_texture = new_dog_node.TEXTURE_B
		2:
			target_texture = new_dog_node.TEXTURE_C
		
	new_dog_node.base_texture = target_texture
	
	#Generate a random color
	var r = rand_range(new_dog_node.COLOR_RANGE.r.x, new_dog_node.COLOR_RANGE.r.y) 
	var g = rand_range(new_dog_node.COLOR_RANGE.g.x, new_dog_node.COLOR_RANGE.g.y) 
	var b = rand_range(new_dog_node.COLOR_RANGE.b.x, new_dog_node.COLOR_RANGE.b.y) 
	new_dog_node.tint = Color(r, g, b)
	
	#Generate random size
	var sx = rand_range(new_dog_node.SCALE_RANGE.x.x, new_dog_node.SCALE_RANGE.x.y) 
	var sy = rand_range(new_dog_node.SCALE_RANGE.y.x, new_dog_node.SCALE_RANGE.y.y) 
	var sz = rand_range(new_dog_node.SCALE_RANGE.z.x, new_dog_node.SCALE_RANGE.z.y) 
	new_dog_node.dog_scale = Vector3(sx,sy,sz)
	
	#How happy is it to start
	new_dog_node.happiness = rand_range(new_dog_node.MIN_START_HAPPINESS, new_dog_node.MAX_START_HAPPINESS)
	
	#Add this dog node to the dog zone
	$DogArea.add_dog(new_dog_node)
	#Show the mat and bowl
	_update_decor(true)

func on_player_action():
	
	#Is the player here?
	if _active and _active_dog_node:
		#We respond!
		get_tree().call_group("game_controller", "player_feed_kennel", self)
		_active_dog_node.feed()
	
	pass

func _on_ActionArea_body_entered(body):
	#For now, assume it's the player
	if body.is_in_group("player"):
		_active = true


func _on_ActionArea_body_exited(body):
	#For now, assume it's the player
	if body.is_in_group("player"):
		_active = false

func _on_Dog_adopted():
	#Announce we got the dog adopted
	emit_signal("dog_adopted")
	
	#Make some changes to the kennel if needed
	
	#Get rid of the dog since it's happy
	_active_dog_node.queue_free()
	#Hide the mat and bowl
	_update_decor(false)
	
	_active_dog_node = null
	
func _update_decor(hasDog):
	$mat.visible = hasDog
	$BowlArea.SetVisible(hasDog)