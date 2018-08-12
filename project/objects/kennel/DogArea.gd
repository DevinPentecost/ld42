extends Spatial

export(Vector2) var area

func add_dog(dog_node):
	
	#Add the dog
	add_child(dog_node)
	
	#Put it there
	var point = get_random_point()
	dog_node.transform.origin.x = point.x
	dog_node.transform.origin.z = point.y
	
	#Rotate it
	dog_node.rotation.y = rand_range(0, 2*PI)

func get_random_point():
	#Find a random spot and return it
	var x_pos = rand_range(-area.x, area.x)
	var z_pos = rand_range(-area.y, area.y)
	var point = Vector2(x_pos, z_pos)
	return point