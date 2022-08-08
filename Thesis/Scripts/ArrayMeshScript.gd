extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var oneFace = [0,2,4,6,8,11,12,15,16,17,18,19]
onready var twoFace = [1,3,5,7,9,10,13,14,20,21,22,23]
onready var threeFace = [0,3,4,7,9,11,13,15,17,18,21,22]
onready var fourFace = [1,2,5,6,8,10,12,14,16,19,20,23]
onready var upFace = [0,1,2,3,8,9,10,11,16,18,20,22]
onready var downFace = [4,5,6,7,12,13,14,15,17,19,22,23]
onready var tool_ = MeshDataTool.new()
onready var oneFaceMesh = get_tree().get_root().get_node("Spatial/Cube/oneFace")
onready var twoFaceMesh = get_tree().get_root().get_node("Spatial/Cube/twoFace")
onready var threeFaceMesh = get_tree().get_root().get_node("Spatial/Cube/threeFace")
onready var fourFaceMesh = get_tree().get_root().get_node("Spatial/Cube/fourFace")
onready var upFaceMesh = get_tree().get_root().get_node("Spatial/Cube/upFace")
onready var downFaceMesh = get_tree().get_root().get_node("Spatial/Cube/downFace")
const ray_length = 1000
onready var holdingButton = false

# Called when the node enters the scene tree for the first time.
func _ready():
	tool_.create_from_surface(mesh,0)
	var vertexCount = tool_.get_vertex_count()
	var tool_ = MeshDataTool.new()
	tool_.create_from_surface(mesh, 0)
	print(vertexCount)
	#var vertexCount = tool_.get_vertex_count()

	for i in range(vertexCount):
		var vert = tool_.get_vertex(i)
#		if(vert in omegaLazy):
#			vert.z += 1
		tool_.set_vertex(i, vert)
		#print("{str1} {str2}".format({"str1":i, "str2":vert}))
		#vert *= 2.0 # Scales the vertex by doubling size.
		#vert.z += 1
	tool_.commit_to_surface(mesh)

func movePointers(xyz, amount, side):
	if(xyz == "z"):
		if(side):
			threeFaceMesh.global_transform.origin.z = amount/2
			fourFaceMesh.global_transform.origin.z = amount/2
			upFaceMesh.global_transform.origin.z = amount/2
			downFaceMesh.global_transform.origin.z = amount/2
		else:
			threeFaceMesh.global_transform.origin.z = amount/2
			fourFaceMesh.global_transform.origin.z = amount/2
			upFaceMesh.global_transform.origin.z = amount/2
			downFaceMesh.global_transform.origin.z = amount/2
	elif(xyz == "x"):
		if(side):
			oneFaceMesh.global_transform.origin.x = amount/2
			twoFaceMesh.global_transform.origin.x = amount/2
			upFaceMesh.global_transform.origin.x = amount/2
			downFaceMesh.global_transform.origin.x = amount/2
		else:
			oneFaceMesh.global_transform.origin.x = amount/2
			twoFaceMesh.global_transform.origin.x = amount/2
			upFaceMesh.global_transform.origin.x = amount/2
			downFaceMesh.global_transform.origin.x = amount/2
	else:
		if(side):
			oneFaceMesh.global_transform.origin.x = amount/2
			twoFaceMesh.global_transform.origin.y = amount/2
			threeFaceMesh.global_transform.origin.y = amount/2
			fourFaceMesh.global_transform.origin.y = amount/2
		else:
			oneFaceMesh.global_transform.origin.x = amount/2
			twoFaceMesh.global_transform.origin.y = amount/2
			threeFaceMesh.global_transform.origin.y = amount/2
			fourFaceMesh.global_transform.origin.y = amount/2
		

func moveVertices(array, amount, xyz, side):
	for i in array:
		var vertex = tool_.get_vertex(i)
		if(xyz == "x"):
			vertex.x = amount*0.7
		elif(xyz == "y"):
			vertex.y = amount*0.4
		else:
			#hacky
			vertex.z = amount*0.9
		tool_.set_vertex(i, vertex)
	movePointers(xyz, amount, side)
	mesh.surface_remove(0)
	tool_.commit_to_surface(mesh)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_StaticBody_input_event_One_Face(camera, event, position, normal, shape_idx):
	#hacky
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if(event.is_pressed()):
			holdingButton = true
		else:
			holdingButton = false
	
	if event is InputEventMouse:
		if(holdingButton):
			var mouse = get_viewport().get_mouse_position()
			var from = camera.project_ray_origin(mouse)
			var to = from + camera.project_ray_normal(mouse) * ray_length
			
			var cast = camera.get_world().direct_space_state.intersect_ray(from, to)
			if not cast.empty():
				var helperVector = Vector3(oneFaceMesh.global_transform.origin.x, oneFaceMesh.global_transform.origin.y, cast['position'][2])
				oneFaceMesh.set_translation(helperVector)
				moveVertices(oneFace, cast['position'][2], "z", true)


func _on_RigidBody_input_event_two_Face(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if(event.is_pressed()):
			holdingButton = true
		else:
			holdingButton = false
	
	if event is InputEventMouse:
		if(holdingButton):
			var mouse = get_viewport().get_mouse_position()
			var from = camera.project_ray_origin(mouse)
			var to = from + camera.project_ray_normal(mouse) * ray_length
			
			var cast = camera.get_world().direct_space_state.intersect_ray(from, to)
			if not cast.empty():
				var helperVector = Vector3(twoFaceMesh.global_transform.origin.x, twoFaceMesh.global_transform.origin.y, cast['position'][2])
				twoFaceMesh.set_translation(helperVector)
				moveVertices(twoFace, cast['position'][2], "z", false)


func _on_RigidBody_input_event_three_Face(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if(event.is_pressed()):
			holdingButton = true
		else:
			holdingButton = false
	
	if event is InputEventMouse:
		if(holdingButton):
			var mouse = get_viewport().get_mouse_position()
			var from = camera.project_ray_origin(mouse)
			var to = from + camera.project_ray_normal(mouse) * ray_length
			
			var cast = camera.get_world().direct_space_state.intersect_ray(from, to)
			if not cast.empty():
				var helperVector = Vector3(cast['position'][0], threeFaceMesh.global_transform.origin.y,  threeFaceMesh.global_transform.origin.z)
				threeFaceMesh.set_translation(helperVector)
				moveVertices(threeFace, cast['position'][0], "x", true)


func _on_RigidBody_input_event_four_Face(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if(event.is_pressed()):
			holdingButton = true
		else:
			holdingButton = false
	
	if event is InputEventMouse:
		if(holdingButton):
			var mouse = get_viewport().get_mouse_position()
			var from = camera.project_ray_origin(mouse)
			var to = from + camera.project_ray_normal(mouse) * ray_length
			
			var cast = camera.get_world().direct_space_state.intersect_ray(from, to)
			if not cast.empty():
				var helperVector = Vector3(cast['position'][0], fourFaceMesh.global_transform.origin.y,  fourFaceMesh.global_transform.origin.z)
				fourFaceMesh.set_translation(helperVector)
				moveVertices(fourFace, cast['position'][0], "x", false)


func _on_RigidBody_input_event_up_Face(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if(event.is_pressed()):
			holdingButton = true
		else:
			holdingButton = false
	
	if event is InputEventMouse:
		if(holdingButton):
			var mouse = get_viewport().get_mouse_position()
			var from = camera.project_ray_origin(mouse)
			var to = from + camera.project_ray_normal(mouse) * ray_length
			
			var cast = camera.get_world().direct_space_state.intersect_ray(from, to)
			if not cast.empty():
				var helperVector = Vector3(upFaceMesh.global_transform.origin.x, cast['position'][1],  upFaceMesh.global_transform.origin.z)
				upFaceMesh.set_translation(helperVector)
				moveVertices(upFace, cast['position'][1], "y", true)


func _on_RigidBody_input_event_down_Face(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if(event.is_pressed()):
			holdingButton = true
		else:
			holdingButton = false
	
	if event is InputEventMouse:
		if(holdingButton):
			var mouse = get_viewport().get_mouse_position()
			var from = camera.project_ray_origin(mouse)
			var to = from + camera.project_ray_normal(mouse) * ray_length
			
			var cast = camera.get_world().direct_space_state.intersect_ray(from, to)
			if not cast.empty():
				var helperVector = Vector3(downFaceMesh.global_transform.origin.x, cast['position'][1],  downFaceMesh.global_transform.origin.z)
				downFaceMesh.set_translation(helperVector)
				moveVertices(downFace, cast['position'][1], "y", false)
