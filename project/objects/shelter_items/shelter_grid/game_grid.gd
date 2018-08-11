extends Spatial

onready var scene_shelter_wall = load("res://objects/shelter_items/tile_wall.tscn")
onready var scene_shelter_floor = load("res://objects/shelter_items/tile_floor.tscn")
onready var scene_shelter_counter = load("res://objects/shelter_items/tile_counter.tscn")
onready var scene_shelter_food = load("res://objects/shelter_items/food_bucket.tscn")
onready var scene_shelter_cage = load("res://objects/shelter_items/tile_kennel.tscn")

var grid_contents = {}
var scene_grid = {}
var kennel_locations = []


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	# We need to load the grid!
	_read_file()
	_create_grid_scenes()
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _create_grid_scenes():
	# Iterate over each row and column
	for row in range(0, grid_contents.size()):
		scene_grid[row] = {}
		for col in range(0, grid_contents[row].size()):
			# Figure out what is at this spot
			var location = {}
			location.row = row
			location.col = col
			
			var square = grid_contents[row][col]
			var type_str = square.type
			var value_str = square.value
			
			# Create the appropriate scene
			var new_scene = null
			var type = int(type_str)
			if type == 0:
				# Void, do nothing
				continue
			if type == 1:
				# Floor
				new_scene = scene_shelter_floor.instance()
			if type == 2:
				# Wall
				new_scene = scene_shelter_wall.instance()
			if type == 3:
				# Counter
				new_scene = scene_shelter_counter.instance() 
			if type == 4:
				# Dog food
				new_scene = scene_shelter_food.instance()
			if type == 5:
				# Kennel
				new_scene = scene_shelter_cage.instance()
				kennel_locations.append(location)
			
			# We need to translate and rotate the scene
			var translation = Vector3(col, 0, row)
			new_scene.translation = translation
			
			var rotation = Vector3(0, 90, 0)
			var value = int(value_str)
			if value == 2:
				rotation = Vector3(0, 0, 0)
			if value == 3:
				rotation = Vector3(0, 270, 0)
			if value == 4:
				rotation = Vector3(0, 180, 0)
			new_scene.rotation_degrees = rotation
			
			# Add it as a child node and add to the master grid
			add_child(new_scene)
			scene_grid[row][col] = new_scene
	# Done with the grid!
	return

func _read_file():
	var file = File.new()
	file.open("res://objects/shelter_items/shelter_grid/game_grid.txt", file.READ)
	
	# Iterate over each line
	var current_line = 0
	while (file.eof_reached() == false):
		# Get the line and make sure its valid
		var line = file.get_line()
		if line == "":
			continue
		if line[0] == '#':
			# Go to the next line
			continue
		
		# Get grid data from this line
		var line_contents = {}
		var split = line.split(" ", false)
		
		for index in range(0, split.size()):
			# Split this square again to get the tile type
			var split_item = split[index].split(",", false)
			
			var tile = {}
			tile.type = split_item[0]
			tile.value = split_item[1]
			
			line_contents[index] = tile
			
		grid_contents[current_line] = line_contents
		current_line = current_line + 1
	
	# Done!
	file.close()
	
	# we have a raw grid, but no scenes/meshes to go with it...
