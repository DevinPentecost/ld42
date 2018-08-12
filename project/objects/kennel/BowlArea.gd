extends Spatial

export(PackedScene) var bowl_scene 
export(Vector2) var area

var _bowlnode

func _ready():
	#Put a bowl in this area
	var x_pos = rand_range(-area.x, area.x)
	var z_pos = rand_range(-area.y, area.y)
	
	#Make a bowl
	_bowlnode = bowl_scene.instance()
	add_child(_bowlnode)
	
	#Put it there
	_bowlnode.transform.origin.x = x_pos
	_bowlnode.transform.origin.z = z_pos

	SetVisible(false)
	
func SetVisible(vis):
	if _bowlnode != null:
		_bowlnode.visible = vis