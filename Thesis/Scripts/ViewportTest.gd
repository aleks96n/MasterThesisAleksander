extends Spatial

var camera1 = null
var camera2 = null
var mesh1 = null
var mesh2 = null
var viewport_sprite1 = null
var viewport_sprite2 = null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	camera1 = get_node("Viewport/Camera")
	camera2 = get_node("Viewport2/Camera")
	mesh1 = get_node("Viewport/MeshInstance")
	mesh2 = get_node("Viewport2/MeshInstance")
	camera1.get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	camera2.get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	
	viewport_sprite1.texture = camera1.get_viewport().get_texture()
	viewport_sprite2.texture = camera2.get_viewport().get_texture()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
