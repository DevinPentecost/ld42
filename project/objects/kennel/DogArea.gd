extends Spatial

export(Vector2) var area

func add_dog(dog_node):
	#Put a bowl in this area
	var x_pos = rand_range(-area.x, area.x)
	var z_pos = rand_range(-area.y, area.y)
	
	#Add the dog
	add_child(dog_node)
	
	#Put it there
	dog_node.transform.origin.x = x_pos
	dog_node.transform.origin.z = z_pos
