extends Spatial

export(PackedScene) var bowl_scene 
export(Vector2) var area

func _ready():
	#Put a bowl in this area
	var x_pos = rand_range(-area.x, area.x)
	var z_pos = rand_range(-area.y, area.y)
	
	#Make a bowl
	var bowl_node = bowl_scene.instance()
	add_child(bowl_node)
	
	#Put it there
	bowl_node.transform.origin.x = x_pos
	bowl_node.transform.origin.z = z_pos