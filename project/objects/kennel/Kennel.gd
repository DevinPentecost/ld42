extends Spatial

signal dog_adopted
signal dog_status_changed

export(PackedScene) var _dog_scene
const _dog_class = preload("res://objects/dog/Dog.gd")
export(bool) var _force_dog_spawn = false #DEBUG ONLY!

var _active_dog_node = null

#Sounds
const pour_sounds = [preload("Pour1.ogg"), preload("Pour2.ogg")]

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
	new_dog_node.connect("happiness_state_changed", self, "_on_Dog_happiness_state_changed")
	
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

func player_action():
	
	#Is the player here?
	if _active_dog_node:
		#We respond!
		get_tree().call_group("game_controller", "player_feed_kennel", self)
		
func play_pour_sound():
	var pour_sound = Helpers.pick_randomly_from_array(pour_sounds)
	$AudioStreamPlayer3D.stream = pour_sound
	$AudioStreamPlayer3D.play()
	
func _on_Dog_adopted():
	#Announce we got the dog adopted
	emit_signal("dog_adopted")
	
	#Make some changes to the kennel if needed
	
	#Get rid of the dog since it's happy
	_active_dog_node.queue_free()
	#Hide the mat and bowl
	_update_decor(false)
	
	_active_dog_node = null
	
func _on_Dog_happiness_state_changed(new_state):
	#Is it upset
	if new_state == _dog_class.BROKEN:
		#Tell the game controller to make a toast
		var toast = "%s is hungry!" % _active_dog_node.dog_name
		get_tree().call_group("toast", "toast", toast)
	
func _update_decor(hasDog):
	$mat.visible = hasDog
	$BowlArea.SetVisible(hasDog)