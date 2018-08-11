extends KinematicBody

#Signals
signal player_action

#Action input from the player
const _action_input_event = "player_action"

#Which movement buttons are pressed
#Done counter_clockwise - top, left, bot, right
const _movement_input_events = ["player_move_up", "player_move_left", "player_move_down", "player_move_right"]
var _movement_input = [false, false, false, false]

#Movement variables
const PI2 = 2*PI
var desired_angle = null
const _player_rotation_speed = 5 #Radians a second?
const _player_movement_speed = 100 #Units per second
const _player_movement_angle = PI/2 #Radians away from target before player starts moving

#Action variables
var _game_over = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	#Handle stuff every frame
	set_process(true)
	
	#Handle input
	set_process_unhandled_input(true)
	
	pass

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
	
func _handle_player_rotation(delta):
	
	#Do we even want to rotate?
	if desired_angle == null:
		return
	
	#Are we already where we want to be?
	if rotation.y == desired_angle:
		return
	
	#How far to move?
	var angular_distance = desired_angle - rotation.y
	
	#Across the circle?
	if angular_distance < 0:
		angular_distance += PI2
	
	#Which way to go?
	var rotation_direction = 1
	if angular_distance > PI:
		#Clockwise
		rotation_direction = -1
	
	#Now rotate that much
	var rotation_amount = _player_rotation_speed * rotation_direction * delta
	var target_rotation = rotation.y + rotation_amount
	
	#Did we go past it?
	if (rotation_direction == 1) and (target_rotation >= desired_angle) or (rotation_direction == -1) and (target_rotation <= desired_angle):
		#Just stop there
		rotation.y = desired_angle
	else:
		#Rotate that amount
		rotation.y = target_rotation
		
	#If we rotated past
	if rotation.y > PI2:
		rotation.y -= PI2

func _handle_player_motion(delta):
	#Is the player moving at all?
	if desired_angle == null:
		return
	
	#First, are we looking close enough to move?
	var angular_distance = abs(rotation.y - desired_angle)
	var angular_distance_mod = abs(rotation.y - (desired_angle + PI2))
	#print('D ', angular_distance, ' DM ', angular_distance_mod)
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
	match _movement_input:
		[true, false, false, false]:
			return 0
		[true, true, false, false]:
			return PI/4
		[false, true, false, false]:
			return 2*PI/4
		[false, true, true, false]:
			return 3*PI/4
		[false, false, true, false]:
			return 4*PI/4
		[false, false, true, true]:
			return 5*PI/4
		[false, false, false, true]:
			return 6*PI/4
		[true, false, false, true]:
			return 7*PI/4
		_:
			return null



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
		
func game_over():
	#Game has ended!
	_game_over = true