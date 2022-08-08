extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var barMesh = self.get_node("bar")
onready var QoL = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if(barMesh):
		barMesh.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func sendSignal():
	var parent = get_parent()
	parent.receiveName(self.name, self)
	if(!self.visible):
		QoL = true
		self.visible = true
	barMesh.visible = true

func disableBar():
	if(QoL):
		QoL = false
		self.visible = false
	barMesh.visible = false


func _on_RigidBody_body_exited(body):
	barMesh.visible = false
