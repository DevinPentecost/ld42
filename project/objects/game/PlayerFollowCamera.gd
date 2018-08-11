extends Camera

#Who to follow
export(NodePath) var follow_target


#The current offset and whether to 'snapshot' on load
export(Vector3) var camera_offset = Vector3(0, 0, 0)
export(Vector3) var camera_angle = Vector3(0, 0, 0)
export(bool) var snapshot_camera_on_ready = true

#Variables for camera movement
export(float) var camera_follow_intensity = 5 #How quickly to catch up to the target
export(bool) var face_target = true #Always point at the target

#For if you want to temporarily use a separate offset but be able to return to the original later
var _using_temporary_position = false
var _temporary_camera_offset = Vector3(0, 0, 0)
var _temporary_camera_rotation = Vector3(0, 0, 0)


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	#Initialize node paths
	follow_target = get_node(follow_target)
	
	#Process every frame
	set_process(true)
	
	#Initialize the camera
	_init_camera()
	
	pass

func _init_camera():
	
	#Are we snapshotting the camera transform?
	if snapshot_camera_on_ready:
		#We need to hold onto the values given in the editor
		camera_offset = global_transform.origin - follow_target.global_transform.origin
		#camera_angle = global_transform.rotation - follow_target.global_transform.rotation

func _process(delta):
	#We need to update the camera position
	_update_transform(delta)
	
func _update_transform(delta):
	
	#Move to be close enough to the player
	#TODO: Interpolate this
	global_transform.origin = follow_target.global_transform.origin + camera_offset
	
	#
	
	#Are we ignoring rotation and always looking at the player?
	if face_target:
		#Set the angle again
		
		#TODO: Make this interpolate nicely?
		transform = global_transform.looking_at(follow_target.global_transform.origin, Vector3(0, 1, 0))
	
	
	pass
