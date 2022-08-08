extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var indices = PoolIntArray()
export var woodMaterial: Material
onready var addedChilden = Array()
# Called when the node enters the scene tree for the first time.
#func _ready():
#	var st = SurfaceTool.new()
#
#	var a = Vector3(0, 1, 0)
#	var b = Vector3(1, 1, 0)
#	var c = Vector3(1, 0, 0)
#	var d = Vector3(0, 0, 0)   # D is at the origin
#	var e = Vector3(1, 1, 1)   # E is opposite of origin
#	var f = Vector3(0, 1, 1)
#	var g = Vector3(0, 0, 1)
#	var h = Vector3(1, 0, 1)
#
#	var verts = PoolVector3Array( [
#	b, a, d, c,    # b, a, d, c,
#	f, e, h, g,    # f, e, h, g,
#	a, f, g, d,    # a, f, g, d,
#	e, b, c, h,    # e, b, c, h,
#	a, b, e, f,    # a, b, e, f,
#	g, h, c, d,    # g, h, c, d,
#	] )
#
##	var verts = PoolVector3Array( [
##    a, b, c, d,    # b, a, d, c,
##    e, f, g, h,    # f, e, h, g,
##    f, a, d, g,    # a, f, g, d,
##    b, e, h, c,    # e, b, c, h,
##    f, e, b, a,    # a, b, e, f,
##    d, c, h, g,    # g, h, c, d,
##	] )
#
#	var uv_a = Vector2(0,0)
#	var uv_b = Vector2(1,0)
#	var uv_c = Vector2(1,1)
#	var uv_d = Vector2(0,1)
#
#	var uvs = PoolVector2Array( [
#	uv_a, uv_b, uv_c, uv_d,    # for the UVs, there's
#	uv_a, uv_b, uv_c, uv_d,    # nothing much to it
#	uv_a, uv_b, uv_c, uv_d,    # in this case
#	uv_a, uv_b, uv_c, uv_d,    # just abcd, abcd...
#	uv_a, uv_b, uv_c, uv_d,
#	uv_a, uv_b, uv_c, uv_d,
#	] )
#
#	add_indices(  0,  1,  2,  3 ) # North (Z axis)
#	add_indices(  4,  5,  6,  7 ) # South
#	add_indices(  8,  9, 10, 11 ) # West  (X axis)
#	add_indices( 12, 13, 14, 15 ) # East
#	add_indices( 16, 17, 18, 19 ) # Top   (Y axis)
#	add_indices( 20, 21, 22, 23 ) # Bottom
#
#	var mi = MeshInstance.new()
#	add_child(mi)
#
#	var mesh = ArrayMesh.new()
#
#	var arrays = []
#	arrays.resize(Mesh.ARRAY_MAX)
#
#	arrays[Mesh.ARRAY_TEX_UV] = uvs
#	arrays[Mesh.ARRAY_VERTEX] = verts
#	arrays[Mesh.ARRAY_INDEX] = indices
#	print(indices)
#	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
#	mesh.surface_set_material(0, woodMaterial)
#
#	mi.mesh = mesh
#	print(mi.translation)
#
#
#func add_indices(a, b, c, d): # these are 'int' indices, not vertices
#	# the West face, or example, points to the vertices [8,10,11,  8,9,10]
#	indices += PoolIntArray([a,c,d,  a,b,c]) 
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta):
##	pass
#
func _unhandled_input(event):
	if event.is_action_pressed("ui_left"):
		var tool_ = MeshDataTool.new()
		print(get_node("TheCube").mesh)
		tool_.create_from_surface(get_node("TheCube").mesh,0)
		var vertexCount = tool_.get_vertex_count()
		print(vertexCount)
	
func _ready():
	var voxelVertices : Array = [
	Vector3(0,0,0),
	Vector3(1,0,0),
	Vector3(1,1,0),
	Vector3(0,1,0),
	Vector3(0,0,1),
	Vector3(1,0,1),
	Vector3(1,1,1),
	Vector3(0,1,1)
	]
	
	var voxelFaces : Array = [
	[3, 0, 1, 1, 2, 3], # back face
	[6, 5, 4, 4, 7, 6], # front face
	[7, 3, 2, 2, 6, 7], # top face
	[0, 4, 5, 5, 1, 0], # bottom face
	[7, 4, 0, 0, 3, 7], # left face
	[2, 1, 5, 5, 6, 2] # right face
	]
	
	var voxelUVs : Array = [
	Vector2(0,1),
	Vector2(0,0),
	Vector2(1,0),
	Vector2(1,0),
	Vector2(1,1),
	Vector2(0,1)
	]
	
	var st1 = SurfaceTool.new()
	st1.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in range(voxelFaces.size()):
		for j in range(6):
			st1.add_uv(voxelUVs[j])
			st1.add_vertex(voxelVertices[voxelFaces[i][j]])
	st1.generate_normals()
	var meshInstance = MeshInstance.new()
	var mesh = st1.commit()
	meshInstance.mesh = mesh
	#woodMaterial.params_cull_mode = woodMaterial.CULL_BACK
	meshInstance.material_override = woodMaterial
	self.add_child(meshInstance)
	meshInstance.set_owner(get_parent())
	var packed_scene = PackedScene.new()
	packed_scene.pack(get_tree().get_current_scene())
	ResourceSaver.save("res://Assets//test_Scene.tscn", packed_scene)
	
	

func _process(delta):
	pass
