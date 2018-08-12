extends KinematicBody

#Signals
signal player_action
signal near_kennel
signal leave_kennel

#Action input from the player
const _action_input_event = "player_action"

#Which movement buttons are pressed
#Done counter_clockwise - top, left, bot, right
const _movement_input_events = ["player_move_up", "player_move_left", "player_move_down", "player_move_right"]
var _movement_input = [false, false, false, false]

#Movement variables
var desired_angle = null
const _player_rotation_lock = 0.1 #Radians to 'lock' to desired angle
const _player_rotation_speed = 2.3 #Radians a second?
const _player_movement_speed = 140 #Units per second
const _player_movement_angle = PI/2 #Radians away from target before player starts moving
var _moving = false
var _rotating = false

#Action variables
var _game_over = false

#Animation
const ANIMATION_BLEND_TIME = 0.25
enum PlayerAnimationState {
	IDLE,
	WALK,
	ACTION,
	LOSE
}
var _animation_state = null

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	#Handle stuff every frame
	set_process(true)
	
	#Handle input
	set_process_unhandled_input(true)
	
	_play_idle_animation()

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	#Move the player
	_handle_player_movement(delta)
	
func _handle_player_movement(delta):

	#Don't move if the game ended
	if _game_over:
		return

	#First, rotate
	_handle_player_rotation(delta)
	
	#Now move
	_handle_player_motion(delta)
	
	#Handle the animation
	if _moving or _rotating:
		_play_walk_animation()
	else:
		_play_idle_animation()
	
func _handle_player_rotation(delta):
	
	#Stop rotating this frame
	_rotating = false
	
	#Do we even want to rotate?
	if desired_angle == null:
		return
	
	#Are we already where we want to be?
	if rotation.y == desired_angle:
		return
	
	#We're rotating
	_rotating = true
	
	#How far to move?
	var angular_distance = desired_angle - rotation.y
	
	#Are we close enough to just face it?
	if abs(angular_distance) <= _player_rotation_lock:
		#Just face it
		rotation.y = desired_angle
		return
	
	#Across the circle?
	if angular_distance < 0:
		angular_distance += PI*2
	
	#Which way to go?
	var rotation_direction = 1
	if angular_distance > PI:
		#Clockwise
		rotation_direction = -1
	
	#Now rotate that much
	var rotation_amount = _player_rotation_speed * rotation_direction
	rotation_amount *= delta
	
	#Do the rotate
	rotation.y += rotation_amount
	
	#If we rotated past
	if rotation.y > PI:
		rotation.y -= 2*PI
	if rotation.y < -PI:
		rotation.y += 2*PI

func _handle_player_motion(delta):
	
	#Stop moving this frame
	_moving = false
	
	#Is the player moving at all?
	if desired_angle == null:
		return
	
	#We're moving now
	_moving = true
	
	#First, are we looking close enough to move?
	var angular_distance = abs(desired_angle - rotation.y)
	var angular_distance_mod = abs(desired_angle - (rotation.y + 2*PI))
	
	#Facing close enough to start moving?
	if angular_distance < _player_movement_angle or angular_distance_mod < _player_movement_angle:
		#We can start moving
		
		#The movement speed depends on how close we are
		var min_distance = min(angular_distance, angular_distance_mod)
		var speed = _player_movement_speed * delta * (_player_movement_angle - min_distance)/_player_movement_angle
		
		#Move the player forward that much
		var velocity = Vector3(speed, 0, 0).rotated(Vector3(0, 1, 0), rotation.y)
		move_and_slide(velocity)

func _calculate_desired_angle():
	#Figure out where the player wants to rotate towards
	#Huge ugly match statement because I'm math dumb
	var angle = null
	match _movement_input:
		[true, false, false, false]:
			angle = 0
		[true, true, false, false]:
			angle = PI/4
		[false, true, false, false]:
			angle = 2*PI/4
		[false, true, true, false]:
			angle = 3*PI/4
		[false, false, true, false]:
			angle = PI
		[false, false, true, true]:
			angle = -3*PI/4
		[false, false, false, true]:
			angle = -2*PI/4
		[true, false, false, true]:
			angle = -PI/4
		_:
			return null
	
	#Adjust the angle
	return angle

func _play_idle_animation():
	
	#If we are petting
	if _animation_state == PlayerAnimationState.ACTION and $PlayerModel/AnimationPlayer.is_playing():
		#We just wait for this one to end
		return
	
	#Set the state
	if _animation_state == PlayerAnimationState.IDLE:
		return
	_animation_state = PlayerAnimationState.IDLE
	
	#Start playing the idle animation
	$PlayerModel/AnimationPlayer.get_animation("idle").loop = true
	$PlayerModel/AnimationPlayer.play("idle", ANIMATION_BLEND_TIME)
	
func _play_walk_animation():
	#Set the state
	if _animation_state == PlayerAnimationState.WALK:
		return
	_animation_state = PlayerAnimationState.WALK
	
	#Start playing the idle animation
	$PlayerModel/AnimationPlayer.get_animation("walk").loop = true
	$PlayerModel/AnimationPlayer.play("walk", ANIMATION_BLEND_TIME)

func _play_action_animation():
	#Set the state
	if _animation_state == PlayerAnimationState.ACTION:
		return
	_animation_state = PlayerAnimationState.ACTION
	
	#Start playing the idle animation
	$PlayerModel/AnimationPlayer.get_animation("pet").loop = false
	$PlayerModel/AnimationPlayer.play("pet", ANIMATION_BLEND_TIME)
	
func _play_lose_animation():
	#Set the state
	if _animation_state == PlayerAnimationState.LOSE:
		return
	_animation_state = PlayerAnimationState.LOSE
	
	#Start playing the idle animation
	$PlayerModel/AnimationPlayer.get_animation("lose").loop = false
	$PlayerModel/AnimationPlayer.play("lose", ANIMATION_BLEND_TIME)
	
func _unhandled_input(event):
	
	#Don't respond to input if the game ended
	if _game_over:
		return
	
	#See if it was movement
	_handle_movement_input(event)
	
	#See if it was action
	_handle_action_input(event)
	
func _handle_movement_input(event):
	
	#Was this one of the movement actions
	for index in range(_movement_input_events.size()):
		#Does it match the input event, and was it pressed or released
		var action_name = _movement_input_events[index]
		if event.is_action_pressed(action_name):
			_movement_input[index] = true
			desired_angle = _calculate_desired_angle()
			break
		elif event.is_action_released(action_name):
			_movement_input[index] = false
			desired_angle = _calculate_desired_angle()
			break
			
	
func _handle_action_input(event):
	
	#Was it a player action?
	if event.is_action_pressed(_action_input_event):
		#Fire off the action
		emit_signal("player_action")
		
		# Tell groups to check player action
		get_tree().call_group("kennel", "on_player_action")
		get_tree().call_group("food", "on_player_action")
		
		#Pet the good boy
		_play_action_animation()
		
func game_over():
	#Game has ended!
	_game_over = true

func _on_InteractArea_area_entered(area):
	
	#Is it a kennel?
	if area.is_in_group("kennel"):
		#We let people know
		emit_signal("near_kennel", area.get_parent())


func _on_InteractArea_area_exited(area):
	#Is it a kennel?
	if area.is_in_group("kennel"):
		#We let people know
		emit_signal("leave_kennel", area.get_parent())
