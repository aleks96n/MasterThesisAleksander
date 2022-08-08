extends Spatial


# Declare member variables here. Examples:
# var a = 2

var dist = 1

# Everything else
onready var origin = get_node("OQ_ARVROrigin")
onready var rayCast = get_node("OQ_ARVROrigin/OQ_LeftController/CustomRayCast")
onready var leftController = get_node("OQ_ARVROrigin/OQ_LeftController")
onready var rightController = get_node("OQ_ARVROrigin/OQ_RightController")
onready var vrCamera = get_node("OQ_ARVROrigin/OQ_ARVRCamera")
onready var loc = get_node("OQ_ARVROrigin/Locomotion_Stick")
onready var assetLamp = load("res://Assets/PlaceLater.tscn")

onready var worldEnvi = get_parent().get_node("WorldEnvironment")
onready var light = get_parent().get_node("WorldEnvironment/DirectionalLight")

export(vr.AXIS) var turn_left_right = vr.AXIS.RIGHT_JOYSTICK_X;
export(vr.AXIS) var turn_up_down = vr.AXIS.RIGHT_JOYSTICK_Y;
onready var y_axis = 5 
onready var done = false
onready var tempMesh


# Called when the node enters the scene tree for the first time.
func _ready():
	if(load("res://DoneTesting.tscn")):
		assetLamp = load("res://DoneTesting.tscn")
	tempMesh = assetLamp.instance()
	tempMesh.scale.x *= 0.2
	tempMesh.scale.y *= 0.2
	tempMesh.scale.z *= 0.2
	self.call_deferred("add_child",tempMesh)
	tempMesh.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	#clean this code up please
	if(done):
		pass
	else:
		var helper = rayCast.returnCollisionPoint()
		if(helper):
			if(leftController._button_pressed(vr.CONTROLLER_BUTTON.INDEX_TRIGGER)):
				tempMesh.visible = true
				tempMesh.global_transform.origin = helper
				tempMesh.global_transform.origin.y = y_axis
				var dlr = -vr.get_controller_axis(turn_left_right);
				tempMesh.rotation.y += dlr*0.05
				
			if(leftController._button_just_released(vr.CONTROLLER_BUTTON.INDEX_TRIGGER)):
				#vr.show_dbg_info("Placing Object...", "Please Wait")
				loc.setMoveSpeed(5)
				origin.global_transform.origin = helper
				vrCamera.current = true
				done = true
				rayCast.removeMarker()
				#removeEverything()

func removeEverything():
	vr.remove_dbg_info("Placing Object...")
	for i in self.get_children():
		self.remove_child(i)

func _on_HSlider_value_changed(value):
	worldEnvi.environment.background_sky.sun_longitude = value
	#make sure this works
	light.rotation_degrees.y = -value


func _on_HLang_value_changed(value):
	worldEnvi.environment.background_sky.sun_latitude = value
	#make sure this works
	light.rotation_degrees.x = -value


func _on_Sunlight_value_changed(value):
	var helper = light.light_color
	var colour = Color(1,1,1,1)
	if(value <= 10):
		colour = Color(helper.r-value*0.1, helper.g-value*0.1, min(1,helper.b+value*0.1), 1)
	elif(value <= 20):
		colour = Color(min(1,helper.r+fmod(value,10)*0.1), min(1,helper.g+fmod(value,10)*0.1), min(1,helper.b+fmod(value,10)*0.1), 1)
	else:
		colour = Color(min(1,helper.r+value*0.1), helper.g-fmod(value,20)*0.1, helper.b-fmod(value,20)*0.1,1)
	light.light_color = colour
