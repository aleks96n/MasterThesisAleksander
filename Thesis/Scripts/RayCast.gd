extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var tempBox = load("res://Assets/TestBox.tscn").instance()
onready var dragging = false
onready var draggingBox = false
onready var changingMaterial = false
onready var originalPosition = Vector3(0,0,0)
onready var helper = null
onready var objectPoint = get_node("Position/ObjectPointer")
onready var typeMaterial : Material = null
onready var deleting = false
export var adjust_left_right = true

export var brickMaterial : Material = null
export var woodMaterial : Material = null
export var glassMaterial : Material = null
export var deleteMaterial : Material = null
export var defaultMaterial : Material = null
#Ui elements

var controller : ARVRController = null;
export(vr.CONTROLLER_BUTTON) var ui_raycast_visible_button := vr.CONTROLLER_BUTTON.TOUCH_INDEX_TRIGGER;
export(vr.CONTROLLER_BUTTON) var ui_raycast_click_button := vr.CONTROLLER_BUTTON.INDEX_TRIGGER;
export(vr.AXIS) var turn_left_right = vr.AXIS.RIGHT_JOYSTICK_X;
export(vr.AXIS) var turn_up_down = vr.AXIS.RIGHT_JOYSTICK_Y;

onready var ui_raycast : RayCast = get_node("Position/RayCast")
onready var ui_raycast_mesh : MeshInstance = self.get_node("Position/MeshInstance")
onready var ui_position : Spatial = self.get_node("Position")
const hand_click_button := vr.CONTROLLER_BUTTON.XA;

func _set_raycast_transform():
	# woraround for now until there is a more standardized way to know the controller
	# orientation
	
	
	if (controller.is_hand):
		if (vr.ovrBaseAPI):
			ui_position.transform = controller.transform.inverse() * vr.ovrBaseAPI.get_pointer_pose(controller.controller_id);
		else:
			ui_position.transform.basis = Basis(Vector3(deg2rad(-90),0,0));
	else:
		ui_position.transform = Transform();
		
		# center the ray cast better to the actual controller position
		if (adjust_left_right):
			ui_position.translation.y = -0.005;
			ui_position.translation.z = -0.01;
		
			if (controller.controller_id == 1):
				ui_position.translation.x = -0.01;
			if (controller.controller_id == 2):
				ui_position.translation.x =  0.01;
		
func _get_collision_point():
	if(ui_raycast.is_colliding()):
		return ui_raycast.get_collision_point()
	else:
		return null
		
func _set_raycast_length(raycast_length):
	ui_raycast.set_cast_to(Vector3(0, 0, -raycast_length));

func _update_raycasts():
	if (controller.is_hand && vr.ovrBaseAPI): # hand has separate logic
		ui_raycast_mesh.visible = vr.ovrBaseAPI.is_pointer_pose_valid(controller.controller_id);
		if (!ui_raycast_mesh.visible): return;
	elif (ui_raycast_visible_button == vr.CONTROLLER_BUTTON.None ||
		  controller._button_pressed(ui_raycast_visible_button) ||
		  controller._button_pressed(ui_raycast_click_button)): 
		ui_raycast_mesh.visible = true;
	else:
		# Process when raycast just starts to not be visible,
		# To allow for button release
		if (!ui_raycast_mesh.visible): return;
		ui_raycast_mesh.visible = false;
		
	_set_raycast_transform();

		
	ui_raycast.force_raycast_update(); # need to update here to get the current position; else the marker laggs behind
	
	
	if ui_raycast.is_colliding():
		var c = ui_raycast.get_collider();
		if (!c.has_method("ui_raycast_hit_event")): return;
		
		var click = false;
		var release = false;
		if (controller.is_hand):
			click = controller._button_just_pressed(hand_click_button);
			release = controller._button_just_released(hand_click_button);
		else:
			click = controller._button_just_pressed(ui_raycast_click_button);
			release = controller._button_just_released(ui_raycast_click_button);
		
		var position = ui_raycast.get_collision_point();
		
		c.ui_raycast_hit_event(position, click, release);

func _ready():
	controller = get_parent();
	if (not controller is ARVRController):
		vr.log_error(" in Feature_UIRayCast: parent not ARVRController.");
	
	ui_raycast.set_cast_to(Vector3(0, 0, -2));

# we use the physics process here be in sync with the controller position
func _physics_process(_dt):
	_update_raycasts();
	mainFunctions()

func measureAxisRotation():
	var dlr = -vr.get_controller_axis(turn_left_right);
	var anotherDlr = -vr.get_controller_axis(turn_up_down);
	var origHeadPos = vr.vrCamera.rotation.y
	if(abs(anotherDlr) > abs(dlr)):
		return Vector3(0,anotherDlr*0.05, 0)
	else:
		if(origHeadPos < 0.5 and origHeadPos > -0.5):
			return Vector3(dlr*0.05, 0, 0)
			#print("-z")
		elif(origHeadPos < -0.5 and origHeadPos > -2.2):
			return Vector3(0,0,dlr*0.05)
			#print("x")
		elif(origHeadPos > -2.2 and origHeadPos < 2.2):
			return Vector3(0,0,-dlr*0.05)
			#print("-x")
		else:
			return Vector3(-dlr*0.05, 0, 0)
			#print("z")

func mainFunctions():
	if deleting:
		if(ui_raycast.is_colliding()):
			if(controller._button_just_released(vr.CONTROLLER_BUTTON.INDEX_TRIGGER)):
				ui_raycast.get_collider().get_parent().remove_and_skip()
	elif dragging:
		var locomotion = self.get_parent().get_parent().get_node("Locomotion_Stick")
		#vr.show_dbg_info("I am", locomotion.get_class())
		locomotion.toggleTurn(false)
		if(controller._button_just_released(vr.CONTROLLER_BUTTON.INDEX_TRIGGER)):
			locomotion.toggleTurn(true)
			dragging = false
		
		#var calculaceDistanceTraveled = originalPosition - get_parent().translation
		var calculaceDistanceTraveled = measureAxisRotation()
		helper.scaleProper(calculaceDistanceTraveled)
		if(calculaceDistanceTraveled != Vector3(0,0,0)):
			originalPosition = get_parent().translation
	elif draggingBox:
		if(controller._button_just_released(vr.CONTROLLER_BUTTON.INDEX_TRIGGER)):
			draggingBox = false
		helper.movingMe(objectPoint.global_transform.origin)
	elif ui_raycast.is_colliding():
		if(controller._button_just_pressed(vr.CONTROLLER_BUTTON.GRIP_TRIGGER) and typeMaterial):
			helper.material = typeMaterial
		#the axis
		if(ui_raycast.get_collider().get_parent().get_class() == "CSGMesh" and ui_raycast.get_collider().get_parent().name != "Floor"):
			moveIt()
		else:
			grabbedAxis()
	else:
		if(helper != null):
			helper.chilling()
		
func newCube(cube):
	changingMaterial = false
	draggingBox = true
	helper = cube

func setMaterial(mat):
	ui_raycast_mesh.material_override = mat
	typeMaterial = mat
	changingMaterial = true

func grabbedAxis():
	var axisHelper = ui_raycast.get_collider().get_parent()
	if axisHelper.has_method("sendSignal"):
		axisHelper.sendSignal()
		#the box itself
		helper = ui_raycast.get_collider().get_parent().get_parent()
		if(controller._button_just_pressed(vr.CONTROLLER_BUTTON.INDEX_TRIGGER)):
			originalPosition = get_parent().translation
			dragging = true

func moveIt():
	#the box
	helper = ui_raycast.get_collider().get_parent()
	helper.chilling()
	if(controller._button_just_pressed(vr.CONTROLLER_BUTTON.INDEX_TRIGGER)):
		draggingBox = true


func _on_Brick_pressed():
	setMaterial(brickMaterial)

func _on_Glass_pressed():
	setMaterial(glassMaterial)

func _on_Wood_pressed():
	setMaterial(woodMaterial)


func _on_DeleteMesh_pressed():
	if(not deleting):
		deleting = true
		ui_raycast_mesh.material_override = deleteMaterial
	else:
		deleting = false
		ui_raycast_mesh.material_override = defaultMaterial
