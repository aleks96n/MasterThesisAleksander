extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var marker = get_node("Marker")
onready var needForMarker = true
#Ui elements

var controller : ARVRController = null;
export(vr.CONTROLLER_BUTTON) var ui_raycast_visible_button := vr.CONTROLLER_BUTTON.TOUCH_INDEX_TRIGGER;
export(vr.CONTROLLER_BUTTON) var ui_raycast_click_button := vr.CONTROLLER_BUTTON.INDEX_TRIGGER;
onready var ui_raycast : RayCast = get_node("Position/RayCast")
onready var ui_raycast_mesh : MeshInstance = self.get_node("Position/MeshInstance")
onready var ui_position : Spatial = self.get_node("Position")
export var adjust_left_right = true
const hand_click_button := vr.CONTROLLER_BUTTON.XA;


# Called when the node enters the scene tree for the first time.
func _ready():
	controller = get_parent();
	if (not controller is ARVRController):
		vr.log_error(" in Feature_UIRayCast: parent not ARVRController.");

func removeMarker():
	needForMarker = false
	marker.visible = false

func _physics_process(_dt):
	_update_raycasts();
	if(needForMarker):
		if ui_raycast.is_colliding():
			marker.visible = true
			marker.global_transform.origin = ui_raycast.get_collision_point()
		else:
			marker.visible = false
		
func returnCollisionPoint():
	if ui_raycast.is_colliding():
		return ui_raycast.get_collision_point()
	else:
		return null
		
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
