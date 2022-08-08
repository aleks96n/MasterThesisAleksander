extends Spatial


# Declare member variables here. Examples:
# var a = 2

# Vector Math
onready var distance = 1

# Everything else
onready var featureRayCast = get_node("OQ_ARVROrigin/OQ_LeftController/Feature_UIRayCast")
onready var lamp = get_node("OQ_ARVROrigin/OQ_LeftController/Feature_UIRayCast/Lamp")
onready var leftController = get_node("OQ_ARVROrigin/OQ_LeftController")
onready var rightController = get_node("OQ_ARVROrigin/OQ_RightController")
onready var vrCamera = get_node("OQ_ARVROrigin/OQ_ARVRCamera")
onready var assetLamp = load("res://Assets/Lamp.tscn")
onready var placing = false
var controller : ARVRController = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(featureRayCast._get_collision_point()):
		print(featureRayCast._get_collision_point())
		lamp.global_transform.origin = featureRayCast._get_collision_point()
	else:
		#print("Seeing nothing")
		pass
	#sensors don't work with OQ toolkit, maybe in the future
	if(distance < 0):
		distance = 0
	if(placing):
		lamp.visible = true
		rightController.get_node("OQ_VisibilityToggle/OQ_UI2DCanvas").visible = false
		if(leftController._button_pressed(vr.CONTROLLER_BUTTON.GRIP_TRIGGER)):		
			pass
		if(leftController._button_just_released(vr.CONTROLLER_BUTTON.GRIP_TRIGGER)):
			var tempMesh = assetLamp.instance()
			tempMesh.global_transform.origin = lamp.global_transform.origin
			tempMesh.scale = lamp.scale
			tempMesh.rotation = lamp.rotation
			self.add_child(tempMesh)
			lamp.visible = false
			placing = false
			rightController.get_node("OQ_VisibilityToggle/OQ_UI2DCanvas").visible = true
	if(leftController._button_just_pressed(vr.CONTROLLER_BUTTON.ENTER)):
		placing = false
		lamp.visible = false
		rightController.get_node("OQ_VisibilityToggle/OQ_UI2DCanvas").visible = true


func _on_Button_pressed():
	placing = true
	lamp.visible = true
	
