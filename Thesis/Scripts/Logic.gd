extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var csgCombiner = get_node("CSGCombiner")
onready var rayCastFunctions = get_node("OQ_ARVROrigin/OQ_LeftController/CustomRayCast")
onready var rightControllerTest = get_node("OQ_ARVROrigin/OQ_RightController")
onready var csgBox = load("res://Assets/CSGBrick.tscn")
onready var vrCamera = load("res://Assets/OQ_ARVROrigin.tscn").instance()
onready var customRect = null
onready var colorRect = null
onready var toggled = true
onready var customHouse = null

export var brickMaterial : Material = null
export var woodMaterial : Material = null
export var glassMaterial : Material = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var perm = OS.get_granted_permissions()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewCube_pressed():
	var anotherHelper = csgBox.duplicate(true)
	var tempHelper = anotherHelper.instance()
	csgCombiner.add_child(tempHelper)
	rayCastFunctions.newCube(tempHelper)

func _on_ChangeTexture_pressed():
	rayCastFunctions.setMaterial(brickMaterial)


func _on_Brick_pressed():
	rayCastFunctions.setMaterial(brickMaterial)


func _on_Glass_pressed():
	rayCastFunctions.setMaterial(glassMaterial)


func _on_Wood_pressed():
	rayCastFunctions.setMaterial(woodMaterial)


func _on_Toggle_pressed():
	toggled = !toggled
	var arrayOfChildren = csgCombiner.get_children()
	for elem in arrayOfChildren:
		for child in elem.get_children():
			if(child.name != "CSGRigidBody"):
				child.visible = toggled

func disableAxis():
	var arrayOfChildren = csgCombiner.get_children()
	for elem in arrayOfChildren:
		for child in elem.get_children():
			if(child.name != "CSGRigidBody"):
				child.visible = false

func _on_Done_pressed():
	disableAxis()
	var spatial = Spatial.new()
	self.add_child(spatial)
	self.remove_child(csgCombiner)
	self.remove_child(vrCamera)
	spatial.add_child(csgCombiner)
	csgCombiner.owner = spatial
	spatial.scale *= 7
	vrCamera.scale *= 0.2
	vrCamera.translation.y += 2
	spatial.add_child(vrCamera)
	vrCamera.owner = spatial
	recursiveOwnership(spatial, csgCombiner)
	var packed_scene = PackedScene.new()
	var result = packed_scene.pack(spatial)
	if result == OK:
		var error = ResourceSaver.save("user://DoneTesting.tscn", packed_scene)
		if error != OK:
			print(error)
		else:
			vr.switch_scene("res://Scenes/TestCity.tscn");

func recursiveOwnership(owner_, node):
	for child in node.get_children():
		child.owner = owner_
		recursiveOwnership(owner_, child)


func _on_Button_pressed():
	customRect = rightControllerTest.get_child(0).get_child(0).get_child(0).get_child(0).get_child(1)
	colorRect = rightControllerTest.get_child(0).get_child(0).get_child(0).get_child(0).get_child(0)
	customRect.visible = true
	colorRect.visible = false
	customRect = customRect.get_child(0).get_child(0)
	var strings = list_files_in_directory("/Android/SpecialFolder/")
	#vr.show_dbg_info("Files", strings)
	var files = importNeeded(strings)
	for f in files:
		var helperLabel : Button = Button.new()
		helperLabel.text = f
		helperLabel.connect("pressed", self,"_on_Custom_File_Pressed",[files[f]])
		customRect.add_child(helperLabel)

#https://godotengine.org/qa/5175/how-to-get-all-the-files-inside-a-folder
func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files

#assumes SpecialFolder
func importNeeded(files):
	var finishedArray = {}
	for f in files:
		if(f.ends_with("obj")):
			var meshInstance = MeshInstance.new()
			var mesh = load(f)
			vr.show_dbg_info("Imported mesh", mesh)
			meshInstance.set_mesh(mesh)
			finishedArray[f] = meshInstance
		elif(f.ends_with("tscn")):
			var scene_ = load(f)
			vr.show_dbg_info("Imported scene", scene_)
			finishedArray[f] = scene_
	return finishedArray

func _on_ColorRect_ready():
	colorRect = get_node("OQ_ARVROrigin/OQ_RightController/OQ_VisibilityToggle/OQ_UI2DCanvas/ReferenceRect/ColorRect")


func _on_CustomRect_ready():
	customRect = get_node("OQ_ARVROrigin/OQ_RightController/OQ_VisibilityToggle/OQ_UI2DCanvas/ReferenceRect/CustomRect")
	
func _on_Custom_File_Pressed(obj):
	var spatial = Spatial.new()
	var inst_ = obj
	if(obj.get_class() != "MeshInstance"):
		inst_ = obj.instance()
	self.add_child(spatial)
	spatial.add_child(inst_)
	self.remove_child(vrCamera)
	spatial.add_child(vrCamera)
	vrCamera.owner = spatial
	inst_.owner = spatial
	
	var packed_scene = PackedScene.new()
	var result = packed_scene.pack(spatial)
	if result == OK:
		var error = ResourceSaver.save("user://DoneTesting.tscn", packed_scene)
		if error != OK:
			vr.show_dbg_info("ERROR", error)
		else:
			vr.switch_scene("res://Scenes/TestCity.tscn");


func _on_Button_Back_pressed():
	customRect = rightControllerTest.get_child(0).get_child(0).get_child(0).get_child(0).get_child(1)
	var vBux = customRect.get_child(0).get_child(0)
	for c in vBux.get_children():
		c.remove_and_skip()
	colorRect = rightControllerTest.get_child(0).get_child(0).get_child(0).get_child(0).get_child(0)
	customRect.visible = false
	colorRect.visible = true

