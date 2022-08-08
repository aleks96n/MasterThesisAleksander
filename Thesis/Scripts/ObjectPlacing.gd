extends Spatial

const raylength = 4444
onready var camera = get_node("Camera")

onready var vrCamera = get_node("OQ_ARVROrigin")
onready var leftController = get_node("OQ_ARVROrigin/OQ_LeftController")
onready var rightController = get_node("OQ_ARVROrigin/OQ_RightController")
onready var rayCast = get_node("OQ_ARVROrigin/OQ_LeftController/Spatial/RayCast")
#onready var poker = get_node("Poker")
onready var tempBox = load("res://Assets/TestBox.tscn").instance()
onready var deleteBox = load("res://Assets/DeleteBox.tscn").instance()
onready var brickBox = load("res://Assets/Brick.tscn")
onready var glassBox = load("res://Assets/Glass.tscn")
onready var woodBox = load("res://Assets/Wood.tscn")
onready var toSaveAsset = self.get_node("ToSaveAsset")

export var glassMaterial : Material
export var woodMaterial : Material
export var brickMaterial : Material

onready var currentMaterial = brickMaterial
onready var cycler = 0


onready var featureRayCast = get_node("OQ_ARVROrigin/OQ_LeftController/Feature_UIRayCast")

export(vr.AXIS) var turn_left_right = vr.AXIS.RIGHT_JOYSTICK_X;
export(vr.AXIS) var turn_up_down = vr.AXIS.RIGHT_JOYSTICK_Y;
onready var objectPositionSaver : Array  = []

onready var placing = true
onready var deleting = false

onready var brick = false
onready var wood = false
onready var glass = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_child(tempBox)
	self.add_child(deleteBox)
	tempBox.visible = false
	deleteBox.visible = false
	
	#iterate over existing objects and add to array
	for elem in toSaveAsset.get_children():
		var helper = converter(elem.global_transform.origin)
		objectPositionSaver.append(helper)

func converter(vector):
	return Vector3(round(vector.x), round(vector.y), round(vector.z))
	
func startDeleting():
	placing = false
	deleting = true
	
func startPlacing():
	placing = true
	deleting = false

func nudgeDirection(helper, x,y,z):
	helper = converter(helper)
	while(helper in objectPositionSaver):
		helper = Vector3(helper.x - x,helper.y-y, helper.z-z)
	return helper
	
func calculateDirection(p1):
	var origHeadPos = vr.vrCamera.rotation.y
	var dlr = -vr.get_controller_axis(turn_left_right)
	var anotherDlr = -vr.get_controller_axis(turn_up_down)
	if(dlr != 0 or anotherDlr != 0):
		if(abs(anotherDlr) > abs(dlr)):
			var helper = Vector3(p1.x,p1.y-anotherDlr*2, p1.z)
			return nudgeDirection(helper, 0, anotherDlr*2, 0)
		else:
			if(origHeadPos < 0.5 and origHeadPos > -0.5):
				var helper = Vector3(p1.x-dlr*2, p1.y, p1.z)
				return nudgeDirection(helper, dlr*2, 0, 0)
			elif(origHeadPos < -0.5 and origHeadPos > -2.2):
				var helper = Vector3(p1.x,p1.y,p1.z-dlr*2)
				return nudgeDirection(helper, 0, 0, dlr*2)
			elif(origHeadPos > -2.2 and origHeadPos < 2.2):
				var helper = Vector3(p1.x,p1.y,p1.z+dlr*2)
				return nudgeDirection(helper, 0,0,-dlr*2)
			else:
				var helper =  Vector3(p1.x+dlr*2, p1.y, p1.z)
				return nudgeDirection(helper, dlr*2, 0,0)
	else:
		return p1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(rayCast.is_colliding() and rayCast.get_collider().get_parent().get_parent().name != "menu"):
		if(placing):
			var p1 = rayCast.get_collider().global_transform.origin
			deleteBox.global_transform.origin = calculateDirection(p1)
			deleteBox.visible = true
			tempBox.visible = false
			
		elif(deleting):
			if(rayCast.get_collider() != null):
				var p1 = rayCast.get_collider().global_transform.origin
				deleteBox.global_transform.origin = calculateDirection(p1)
				deleteBox.visible = true
				tempBox.visible = false
	else:
		tempBox.visible = false
		
	if(rightController._button_just_pressed(vr.CONTROLLER_BUTTON.GRIP_TRIGGER)):	
		if(placing):
			if(rayCast.is_colliding()):
				var placingCoordinates = calculateDirection(rayCast.get_collider().global_transform.origin)
				placingCoordinates = converter(placingCoordinates)
				if(!(placingCoordinates in objectPositionSaver)):
					objectPositionSaver.append(placingCoordinates)
					var temp = brickBox.instance()
					temp.global_transform.origin = placingCoordinates
					toSaveAsset.add_child(temp)
					#self.add_child(temp)
		elif(deleting):
			if(rayCast.is_colliding()):
				if(rayCast.get_collider() != null):
					var placingCoordinates = calculateDirection(rayCast.get_collider().global_transform.origin)
					placingCoordinates = converter(placingCoordinates)
					objectPositionSaver.erase(placingCoordinates)
					var p1 = rayCast.get_collider().get_parent()
					p1.queue_free()

	if(leftController._button_just_pressed(vr.CONTROLLER_BUTTON.GRIP_TRIGGER)):
		if(rayCast.is_colliding() and rayCast.get_collider().get_parent().get_parent().name != "menu"):
			var thing : MeshInstance = rayCast.get_collider().get_parent()
			thing.material_override = currentMaterial
			
	if(leftController._button_just_released(vr.CONTROLLER_BUTTON.XA)):
		changeMaterial()
			
			

func changeMaterial():
	#cycle through the three materials after every A button press
	if(cycler == 0):
		cycler += 1
		currentMaterial = woodMaterial
	elif(cycler == 1):
		cycler +=1
		currentMaterial = glassMaterial
	else:
		cycler = 0
		currentMaterial = brickMaterial
			

func calculateDirectionOfCollisionShape(castPoint, collisionPoint):
	var product = castPoint - collisionPoint
	var placingCoordinates = Vector3(0,0,0)
	if(int(round(product.x)) == -1):
		placingCoordinates = Vector3(collisionPoint.x-2, collisionPoint.y, collisionPoint.z)
	elif(int(round(product.x)) == 1):
		placingCoordinates = Vector3(collisionPoint.x+2, collisionPoint.y, collisionPoint.z)
	elif(int(round(product.y)) == -1):
		placingCoordinates = Vector3(collisionPoint.x, collisionPoint.y-2, collisionPoint.z)
	elif(int(round(product.y)) == 1):
		placingCoordinates = Vector3(collisionPoint.x, collisionPoint.y+2, collisionPoint.z)
	elif(int(round(product.z)) == -1):
		placingCoordinates = Vector3(collisionPoint.x, collisionPoint.y, collisionPoint.z-2)
	elif(int(round(product.z)) == 1):
		placingCoordinates = Vector3(collisionPoint.x, collisionPoint.y, collisionPoint.z+2)
	return placingCoordinates


func _on_RigidBody_body_exited(body):
	tempBox.visible = false
			
func recursiveOwnership(owner_, node):
	for child in node.get_children():
		child.owner = owner_
		recursiveOwnership(owner_, child)



func _on_Done_pressed():
	var spatial = Spatial.new()
	self.add_child(spatial)
	self.remove_child(toSaveAsset)
	self.remove_child(vrCamera)
	spatial.add_child(toSaveAsset)
	toSaveAsset.owner = spatial
	spatial.scale *= 7
	recursiveOwnership(spatial, toSaveAsset)
	var packed_scene = PackedScene.new()
	var result = packed_scene.pack(spatial)
	if result == OK:
		var error = ResourceSaver.save("res://DoneTesting.tscn", packed_scene)
		if error != OK:
			print(error)
		else:
			vr.switch_scene("res://Scenes/TestCity.tscn");


func _on_Custom_pressed():
	var spatial = Spatial.new()
	var inst_ = load("res://Assets/Custom.tscn")
	#if(obj.get_class() != "MeshInstance"):
	inst_ = inst_.instance()
	self.add_child(spatial)
	spatial.add_child(inst_)
	#self.remove_child(vrCamera)
	#spatial.add_child(vrCamera)
	#vrCamera.owner = spatial
	inst_.owner = spatial
	
	var packed_scene = PackedScene.new()
	var result = packed_scene.pack(spatial)
	if result == OK:
		var error = ResourceSaver.save("res://DoneTesting.tscn", packed_scene)
		if error != OK:
			vr.show_dbg_info("ERROR", error)
		else:
			vr.switch_scene("res://Scenes/TestCity.tscn");


func _on_Brick_pressed():
	currentMaterial = brickMaterial


func _on_Glass_pressed():
	currentMaterial = glassMaterial


func _on_Wood_pressed():
	currentMaterial = woodMaterial
