extends Spatial

onready var scene_shelter_wall = load("res://objects/basic_tiles/WallTile.tscn")
onready var scene_shelter_floor = load("res://objects/basic_tiles/FloorTile.tscn")
onready var scene_shelter_counter = load("res://objects/basic_tiles/CounterTile.tscn")
onready var scene_shelter_food = load("res://objects/food_bucket/FoodBucket.tscn")
onready var scene_shelter_cage = load("res://objects/kennel/Kennel.tscn")

#Grid sizing
const TILE_SIZE = 4

# Contents of the grid, as provided by the input file
var grid_contents = {}

# Scene grid, containing all of the scened in the grid
var scene_grid = {}

# Array of kennel locations (array of dictionaries with contents {row, col})
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

const _tile_void = 0
const _tile_floor = 1
const _tile_wall = 2
const _tile_counter = 3
const _tile_food = 4
const _tile_kennel = 5

const _direction_down = 1
const _direction_left = 2
const _direction_up = 3
const _direction_right = 4


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
			var direction = square.value
			
			# Create the appropriate scene
			var new_scene = null
			match int(type_str):
				_tile_void:
					# Void, do nothing
					continue
				_tile_floor:
					# Floor
					new_scene = scene_shelter_floor.instance()
				_tile_wall:
					# Wall
					new_scene = scene_shelter_wall.instance()
				_tile_counter:
					# Counter
					new_scene = scene_shelter_counter.instance() 
				_tile_food:
					# Dog food
					new_scene = scene_shelter_food.instance()
				_tile_kennel:
					# Kennel
					new_scene = scene_shelter_cage.instance()
					kennel_locations.append(location)
			
			# We need to translate and rotate the scene
			var translation = Vector3(-row * TILE_SIZE, 0, col * TILE_SIZE)
			new_scene.translation = translation
			
			#Update rotation
			var rotation = Vector3(0, 0, 0)
			match int(direction):
				_direction_left:
					rotation.y = 90
				_direction_right:
					rotation.y = -90
				_direction_down:
					rotation.y = 180
			new_scene.rotation_degrees = rotation
			
			# Add it as a child node and add to the master grid
			add_child(new_scene)
			scene_grid[row][col] = new_scene
	# Done with the grid!
	return

func _read_file():
	var file = File.new()
	file.open("res://data/game_grid.txt", file.READ)
	
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

func get_all_kennels():
	var output = []
	for location in kennel_locations:
		output.append(scene_grid[location.row][location.col])
		
	return output