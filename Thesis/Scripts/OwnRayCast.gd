extends Spatial


export var active := true;
export var ui_raycast_length := 3.0;
export var ui_mesh_length := 1.0;
const hand_click_button := vr.CONTROLLER_BUTTON.XA;
export var adjust_left_right := true;

export(vr.CONTROLLER_BUTTON) var ui_raycast_visible_button := vr.CONTROLLER_BUTTON.TOUCH_INDEX_TRIGGER;
export(vr.CONTROLLER_BUTTON) var ui_raycast_click_button := vr.CONTROLLER_BUTTON.INDEX_TRIGGER;

var controller : ARVRController = null;
onready var ui_raycast : RayCast = get_node("RayCast")
onready var ui_raycast_mesh : MeshInstance = $RayCastMesh;
var is_colliding := false;

# Called when the node enters the scene tree for the first time.
func _ready():
	controller = get_parent();
	if (not controller is ARVRController):
		vr.log_error(" in Feature_UIRayCast: parent not ARVRController.");
		
	ui_raycast.set_cast_to(Vector3(0, 0, -ui_raycast_length));
	
	#setup the mesh
	ui_raycast_mesh.mesh.size.z = ui_mesh_length;
	ui_raycast_mesh.translation.z = -ui_mesh_length * 0.5;
	
	ui_raycast_mesh.visible = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		


func _set_raycast_transform():
	# woraround for now until there is a more standardized way to know the controller
	# orientation
	return;
	if (controller.is_hand):
		if (vr.ovrBaseAPI):
			ui_raycast.transform = controller.transform.inverse() * vr.ovrBaseAPI.get_pointer_pose(controller.controller_id);
		else:
			ui_raycast.transform.basis = Basis(Vector3(deg2rad(-90),0,0));
	else:
		ui_raycast.transform = Transform();
		
		# center the ray cast better to the actual controller position
		if (adjust_left_right):
			ui_raycast.translation.y = -0.005;
			ui_raycast.translation.z = -0.01;
		
			if (controller.controller_id == 1):
				ui_raycast.translation.x = -0.01;
			if (controller.controller_id == 2):
				ui_raycast.translation.x =  0.01;
				
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
		is_colliding = true;
	else:
		is_colliding = false;

func _physics_process(_dt):
	if (!active): return;
	if (!visible): return;
	_update_raycasts();
