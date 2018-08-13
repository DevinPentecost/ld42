extends Spatial

#Materials to use for normal and highlight
export(Material) var normal_material
export(Material) var highlight_material

# External facing things
export var max_food = 100
export var food_regenerate_per_second = 1
export var food_given_when_activated = 30
export var activation_cooldown_seconds = 15

signal on_cooldown_done
signal on_food_full


# Internal things
var _active = false
var current_cooldown_seconds = 0
var current_food = max_food / 2

var can_emit_cooldown_signal = false
var can_emit_food_full_signal = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta_seconds):
	# We need to see how much food to add
	current_food = current_food + (food_regenerate_per_second * delta_seconds)
	if current_food >= max_food:
		current_food = max_food
		if can_emit_food_full_signal == true:
			can_emit_food_full_signal = false
			emit_signal("on_food_full")
	
	# What about cooldown?
	current_cooldown_seconds = current_cooldown_seconds - delta_seconds
	if current_cooldown_seconds <= 0:
		current_cooldown_seconds = 0
		if can_emit_cooldown_signal == true:
			can_emit_cooldown_signal = false
			emit_signal("on_cooldown_done")
	
	pass

func request_food():
	# If its time to give food, give it!
	var food_to_give = 0
	if current_cooldown_seconds > 0:
		return food_to_give
	
	# Give the asker whatever food we can and intiate cooldown
	food_to_give = food_given_when_activated
	if food_to_give > current_food:
		food_to_give = current_food
	
	current_cooldown_seconds = activation_cooldown_seconds
	current_food = current_food - food_to_give
	
	# Enable signal emitters
	can_emit_food_full_signal = true
	can_emit_cooldown_signal = true
	
	return food_to_give

func _update_material():
	#Are we in range of the user?
	var material = normal_material
	if _active:
		material = highlight_material
		
	#Update the bucket
	$Bucket/Cylinder.mesh.surface_set_material(0, material)

func on_player_action():
	#Is the player interacting with the bucket?
	if _active:
		# Give the player food!
		get_tree().call_group("game_controller", "fill_player_food", null)
		
		#Let the player know!
		var toast = "Grabbed some dog food"
		get_tree().call_group("toast", "toast", toast)

func _on_ActionArea_body_entered(body):
	#For now, assume it's the player
	if body.is_in_group("player"):
		_active = true
	_update_material()

func _on_ActionArea_body_exited(body):
	#For now, assume it's the player
	if body.is_in_group("player"):
		_active = false
	_update_material()
