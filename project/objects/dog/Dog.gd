extends Spatial

signal adopted

#Debbing
var _debugging = false

#Properties of doggo
const SCALE_RANGE = Vector2(0.8, 1.5)
const TEND_RATE_RANGE = Vector2(0.1, 0.15)
const ADOPTION_RATE_RANGE = Vector2(0.1, 0.15)
const COLOR_RANGE = {
	'r': Vector2(0, 1),
	'g': Vector2(0, 1),
	'b': Vector2(0, 1)
}
export(Texture) var TEXTURE_A
export(Texture) var TEXTURE_B
onready var TEXTURES = [TEXTURE_A, TEXTURE_B]

#All the various properties of a dog
export(String) var dog_name
export(String) var description = "This hound needs a description!"
export(float) var dog_scale = 1.0
export(Texture) var base_texture
export(Color) var tint
export(float) var tend_rate = 0.0001
export(float) var adoption_rate = 0.01
var _secondCounter = 0.0

# Refs to other nodes
var bio
var dpar
var emojiRef
onready var _dog_area = $".."

#Properties of the dog's status
const MIN_START_HAPPINESS = 0.1
const MAX_START_HAPPINESS = 0.8
const MIN_ADOPTION_HAPPINESS = 0.3
const ABONDONDED_ADOPTIONDECAY = 0.0003
const ADOPTION_CHANCERATIO = 0.2 # this * adoption meter is chance of early adoption per second
var happiness = rand_range(MIN_START_HAPPINESS, MAX_START_HAPPINESS)
var adoption = 0

#Animation stuff
const MIN_WAIT_TIME = 2
const MAX_WAIT_TIME = 5
const MIN_MOVE_TIME = 2
const MAX_MOVE_TIME = 4
const ANIMATION_BLEND_TIME = 0.5
const SIT_STAND_TIME = 1
const TURN_TIME = 1
enum DogAnimationState {
	STAND,
	WALK,
	SIT,
	CHANGING
}
var _animation_state = null

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	dpar = $"../.."
	emojiRef = self.find_node("emoter")
	
	# Generate a bio
	bio = self.find_node("Biography")
	dog_name = bio.Name
	description = bio.Bio
	
	#Create the model and stuff here
	set_process(true)
	
	#Pick a state randomly
	match(randi() % 2):
		0:
			_play_sit_animation()
		1:
			_play_stand_animation()
			
	#Start the timer
	_reset_action_timer()

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	_secondCounter += delta
	
	_update_status(delta)
	
	#Tell our parent to let folks know we've updated
	
	if dpar != null:
		$"../..".emit_signal("dog_status_changed")
	

func _update_status(delta):
	
	#Lower the happiness by the tend rate
	happiness -= tend_rate * delta
	happiness = max(happiness, 0)
	
	#Update adoption meter depending on happiness
	if happiness >= MIN_ADOPTION_HAPPINESS:
		adoption += adoption_rate * delta * max(min(pow(happiness, 3), 1), 0.1)
		
		emojiRef.ShowHeart(10)
	elif happiness <= 0.0:
		adoption -= ABONDONDED_ADOPTIONDECAY * delta
		emojiRef.ShowHeartBroken(10)
	else:
		emojiRef.ShowAnger(10)
	
	# Determine if dog is adopted
	if happiness > 0.0:
		#Adoption can only occur while a dog is not heartbroken.
		if adoption >= 1:
			#Someone adopted us
			emit_signal("adopted")
			set_process(false)
			
		# Adoption can occur earlier by chance.
		if _secondCounter > 1.0:
			_secondCounter = 0.0
			randomize()
			if randf() < adoption * ADOPTION_CHANCERATIO:
				#Someone adopted us
				emit_signal("adopted")
				set_process(false)
				print("early adoption!")
		
		
func feed():
	#The dog is fed and happy!
	happiness = 1
	
func _play_sit_animation():
	#Set the state
	if _animation_state == DogAnimationState.SIT:
		return
	_animation_state = DogAnimationState.SIT
	
	#Start playing the idle animation
	$dogmodel/AnimationPlayer.get_animation("sit").loop = true
	$dogmodel/AnimationPlayer.play("sit", ANIMATION_BLEND_TIME)

func _play_stand_animation():
	#Set the state
	if _animation_state == DogAnimationState.STAND:
		return
	_animation_state = DogAnimationState.STAND
	
	#Start playing the idle animation
	$dogmodel/AnimationPlayer.get_animation("stand").loop = true
	$dogmodel/AnimationPlayer.play("stand", ANIMATION_BLEND_TIME)
	
func _play_walk_animation():
	#Set the state
	if _animation_state == DogAnimationState.WALK:
		return
	_animation_state = DogAnimationState.WALK
	
	#Start playing the idle animation
	$dogmodel/AnimationPlayer.get_animation("walk").loop = true
	$dogmodel/AnimationPlayer.play("walk", ANIMATION_BLEND_TIME)
	
func _blend_to_state(target_animation, blend_time):
	#Play the animation but really slowly
	$dogmodel/AnimationPlayer.play(target_animation, blend_time)
	yield($dogmodel/AnimationPlayer, "animation_finished")
	
func _walk_to_point(target_point=null):
	#Find a point?
	if not target_point:
		target_point = _dog_area.get_random_point()
		
	#Are we currently sitting?
	if _animation_state == DogAnimationState.SIT:
		#We need to get up
		_blend_to_state("stand", SIT_STAND_TIME)
	
	#Now we can turn to face the point
	var target_position = Vector3(target_point.x, translation.y, target_point.y)
	var angle = translation.angle_to(target_position)
	$Tween.interpolate_property(self, "rotation", rotation, rotation + Vector3(0, angle, 0), TURN_TIME, Tween.TRANS_EXPO, Tween.EASE_OUT_IN)
	$Tween.start()
	yield($Tween, "tween_completed")
	
	#Now start walking to it
	_play_walk_animation()
	var move_time = rand_range(MIN_MOVE_TIME, MAX_MOVE_TIME)
	$Tween.interpolate_property(self, "translation", translation, target_position, move_time, Tween.TRANS_EXPO, Tween.EASE_OUT_IN)
	$Tween.start()
	yield($Tween, "tween_completed")
	
	#Done walking, stand still
	_play_stand_animation()
	
	

func _rotate_to_angle():
	#Pick a random angle
	var new_angle = rand_range(0, 2*PI)
	
	#Rotate that way
	var move_time = rand_range(MIN_MOVE_TIME, MAX_MOVE_TIME)
	var new_rotation = Vector3(rotation.x, new_angle, rotation.z)
	$Tween.interpolate_property(self, "rotation", rotation, new_rotation, move_time, Tween.TRANS_EXPO, Tween.EASE_OUT_IN)
	$Tween.start()
	yield($Tween, "tween_completed")

func _toggle_sit_stand():
	#Are we currently sitting?
	if _animation_state == DogAnimationState.SIT:
		#We need to get up
		_blend_to_state("stand", SIT_STAND_TIME)
		_play_stand_animation()
	elif _animation_state == DogAnimationState.STAND:
		#We need to sit
		_blend_to_state("sit", SIT_STAND_TIME)
		_play_sit_animation()

func _reset_action_timer():
	#Pick a time
	$Timer.wait_time = rand_range(MIN_WAIT_TIME, MAX_WAIT_TIME)
	$Timer.start()
	yield($Timer, "timeout")
	
	#Possible actions are rotate, toggle sit/stand, and move to new position
	var actions = ['sit_stand', 'walk']
	if _animation_state != DogAnimationState.SIT:
		actions.append('rotate')
	
	#Pick an action
	var index = randi() % actions.size()
	match actions[index]:
		'rotate':
			#Just rotate to a new angle
			_rotate_to_angle()
		'sit_stand':
			#Sit or stand
			_toggle_sit_stand()
		'walk':
			#Move somewhere new
			_walk_to_point()
			
	#We're here, set the timer to do something else
	_reset_action_timer()