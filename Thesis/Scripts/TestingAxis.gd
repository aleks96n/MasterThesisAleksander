extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(vr.AXIS) var turn_left_right = vr.AXIS.RIGHT_JOYSTICK_X;
export(vr.AXIS) var turn_up_down = vr.AXIS.RIGHT_JOYSTICK_Y;
# Called when the node enters the scene tree for the first time.
func _ready():
	var strings = list_files_in_directory("res://SpecialFolder")
	print(importNeeded(strings))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	var dlr = -vr.get_controller_axis(turn_left_right);
#	var anotherDlr = -vr.get_controller_axis(turn_up_down);
#	var origHeadPos = vr.vrCamera.rotation.y
#	if(origHeadPos < 0.5 and origHeadPos > -0.5):
#		print("-z")
#	elif(origHeadPos < -0.5 and origHeadPos > -2.2):
#		print("x")
#	elif(origHeadPos > -2.2 and origHeadPos < 2.2):
#		print("-x")
#	else:
#		print("z")
	pass
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
	var finishedArray = []
	for f in files:
		if(f.ends_with("obj")):
			var meshInstance = MeshInstance.new()
			var mesh = load("res://SpecialFolder/"+f)
			meshInstance.set_mesh(mesh)
			finishedArray.append(meshInstance)
		elif(f.ends_with("tscn")):
			var scene_ = load("res://SpecialFolder/"+f)
			finishedArray.append(scene_)
	return finishedArray
		
