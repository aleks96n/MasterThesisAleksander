extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var logicZ = get_parent().get_parent()
onready var myParent = get_parent()
onready var originalMaterial = myParent.mesh.surface_get_material(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func changeToOrigin():
	myParent.material_override = originalMaterial

func changeToNew(mat):
	myParent.material_override = mat
	
func ui_raycast_hit_event(one,two,three):
	logicZ.logicButtons(myParent.name)
	
