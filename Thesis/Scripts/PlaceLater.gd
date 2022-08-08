extends Spatial


onready var endPoint = get_node("OQ_ARVROrigin/OQ_LeftController/Feature_UIRayCast/EndPoint")
onready var startPoint = get_node("OQ_ARVROrigin/OQ_LeftController/Feature_UIRayCast/StartPoint")
onready var lampPoint = get_node("OQ_ARVROrigin/OQ_LeftController/Feature_UIRayCast/LampPoint")
onready var distance = 1

# Everything else
onready var lamp = get_node("OQ_ARVROrigin/OQ_LeftController/Feature_UIRayCast/LampPoint/Lamp")
onready var leftController = get_node("OQ_ARVROrigin/OQ_LeftController")
onready var rightController = get_node("OQ_ARVROrigin/OQ_RightController")
onready var assetLamp = load("res://Assets/Lamp.tscn")
onready var vrCamera = get_node("OQ_ARVROrigin")


var speed = 1.5
onready var degrees = 1
onready var unbaked = true
onready var placing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(distance < 0):
		distance = 0
	if(placing):
		lamp.visible = true
		rightController.get_node("OQ_VisibilityToggle/OQ_UI2DCanvas").visible = false
		if(leftController._button_pressed(vr.CONTROLLER_BUTTON.GRIP_TRIGGER)):		
			if(leftController._button_pressed(vr.CONTROLLER_BUTTON.YB)):
				distance += 0.3
				lampPoint.translation = calculateVector()
			elif(leftController._button_pressed(vr.CONTROLLER_BUTTON.XA)):
				distance -= 0.3
				lampPoint.translation = calculateVector()
		if(leftController._button_just_released(vr.CONTROLLER_BUTTON.GRIP_TRIGGER)):
			print("Pressing")
			var tempMesh = assetLamp.instance()
			tempMesh.global_transform.origin = lampPoint.global_transform.origin
			self.get_parent().add_child(tempMesh)
			print(tempMesh.translation)
			print(tempMesh.global_transform.origin)
			lamp.visible = false
			placing = false
			rightController.get_node("OQ_VisibilityToggle/OQ_UI2DCanvas").visible = true
	if(leftController._button_just_pressed(vr.CONTROLLER_BUTTON.ENTER)):
		placing = false
		lamp.visible = false
		rightController.get_node("OQ_VisibilityToggle/OQ_UI2DCanvas").visible = true


func _on_Button_pressed():
	if(unbaked):
		var giProbe = get_parent().get_node("GIProbe")
		giProbe.global_transform.origin = self.global_transform.origin
		giProbe.visible = true
		giProbe.bake()
	else:
		var giProbe = get_parent().get_node("GIProbe")
		giProbe.visible = false

#1st floor	
func _on_Button2_pressed():
	vrCamera.translation.y = 10

#2nd floor
func _on_Button3_pressed():
	vrCamera.translation.y = 27


func _on_HSlider_value_changed(value):
	var worldEnvi = get_parent().get_node("WorldEnvironment")
	var light = get_parent().get_node("WorldEnvironment/DirectionalLight")
	worldEnvi.environment.background_sky.sun_longitude = value
	#make sure this works
	light.rotation_degrees.y = -value


func calculateVector():
	# can shorten this, but just in case I get demented
	var P1 = startPoint.translation
	var P2 = endPoint.translation
	var lineVector = Vector3(P2.x - P1.x, P2.y - P1.y, P2.z - P1.z)
	var lineLength = sqrt(pow(lineVector.x,2) + pow(lineVector.y,2) + pow(lineVector.z,2))
	var lineVersor = lineVector/lineLength
	var targetPoint = P1 + distance*lineVersor
	return targetPoint


func _on_placeLamp_pressed():
	placing = true
	lamp.visible = true
