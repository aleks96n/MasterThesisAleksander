extends CSGMesh


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var csgBox : CSGMesh = self
onready var lastAxis = "NAN"
onready var touchedCSG = null
onready var upFace = [0, 4, 5, 6, 10, 11, 12, 13, 14, 15, 16, 17, 24, 28, 29, 30, 34, 35]
onready var downFace = [1, 2, 3, 7, 8, 9, 18, 19, 20, 21, 22, 23, 25, 26, 27, 31, 32, 33]
onready var leftFace = [0, 1, 5, 8, 9, 10, 12, 13, 17, 18, 19, 23, 24, 25, 26, 27, 28, 29]
onready var rightFace = [2, 3, 4, 6, 7, 11, 14, 15, 16, 20, 21, 22, 30, 31, 32, 33, 34, 35]
onready var backFace = [0, 1, 2, 3, 4, 5, 13, 14, 15, 18, 22, 23, 26, 27, 28, 30, 31, 35]
onready var frontFace = [6, 7, 8, 9, 10, 11, 12, 16, 17, 19, 20, 21, 24, 25, 29, 32, 33, 34]
onready var tool_ = MeshDataTool.new()
onready var hackyMesh = null
onready var allAxis = self.get_children()
# Called when the node enters the scene tree for the first time.
func _ready():
	allAxis.pop_back()
	tool_.create_from_surface(mesh, 0)

func scaleProper(direction):
	#csgBox.translation.ro
	if(lastAxis == "RightUpper"):
		if(abs(direction.y) > abs(direction.x)):
			if(hackyMesh):
				hackyMesh.translation.y -= direction.y
			for i in upFace:
				var vertex = tool_.get_vertex(i)
				vertex.y -= direction.y
				tool_.set_vertex(i, vertex)
			communicateWithAxis(lastAxis, null, null, null, "y", direction.y, null, null)
		else:
			if(hackyMesh):
				hackyMesh.translation.x -= direction.x
			for i in leftFace:
				var vertex = tool_.get_vertex(i)
				vertex.x -= direction.x
				tool_.set_vertex(i, vertex)
			communicateWithAxis(allAxis[4], allAxis[5], allAxis[2], allAxis[1], "x", direction.x, -direction.x, null)
	elif(lastAxis == "LeftUpper"):
		if(abs(direction.y) > abs(direction.x)):
			if(hackyMesh):
				hackyMesh.translation.y -= direction.y
			for i in upFace:
				var vertex = tool_.get_vertex(i)
				vertex.y -= direction.y
				tool_.set_vertex(i, vertex)
			communicateWithAxis(lastAxis, null, null, null, "y", direction.y, null, null)
		else:
			if(hackyMesh):
				hackyMesh.translation.x -= direction.x
			for i in rightFace:
				var vertex = tool_.get_vertex(i)
				vertex.x -= direction.x
				tool_.set_vertex(i, vertex)
			communicateWithAxis(allAxis[4], allAxis[5], allAxis[0], allAxis[3], "x", direction.x, null, null)
	elif(lastAxis == "TopUpper"):
		if(abs(direction.y) > abs(direction.x)):
			if(hackyMesh):
				hackyMesh.translation.y -= direction.y
			for i in upFace:
				var vertex = tool_.get_vertex(i)
				vertex.y -= direction.y
				tool_.set_vertex(i, vertex)
			communicateWithAxis(lastAxis, null, null, null, "y", direction.y, null, null)
		else:
			if(hackyMesh):
				hackyMesh.translation.z -= direction.z
			for i in frontFace:
				var vertex = tool_.get_vertex(i)
				vertex.z -= direction.z
				tool_.set_vertex(i, vertex)
			communicateWithAxis(allAxis[6], allAxis[7], allAxis[1], allAxis[0], "z", direction.z, null, null)
	elif(lastAxis == "BottomUpper"):
		if(abs(direction.y) > abs(direction.x)):
			if(hackyMesh):
				hackyMesh.translation.y -= direction.y
			for i in upFace:
				var vertex = tool_.get_vertex(i)
				vertex.y -= direction.y
				tool_.set_vertex(i, vertex)
			communicateWithAxis(lastAxis, null, null, null, "y", direction.y, null, null)
		else:
			if(hackyMesh):
				hackyMesh.translation.z -= direction.z
			for i in backFace:
				var vertex = tool_.get_vertex(i)
				vertex.z -= direction.z
				tool_.set_vertex(i, vertex)
			communicateWithAxis(allAxis[6], allAxis[7], allAxis[3], allAxis[2], "z", direction.z, direction.z, null)
	elif(lastAxis == "BottomRight"):
		if(abs(direction.z) > abs(direction.x)):
			if(hackyMesh):
				hackyMesh.translation.z -= direction.z
			for i in backFace:
				var vertex = tool_.get_vertex(i)
				vertex.z -= direction.z
				tool_.set_vertex(i, vertex)
			communicateWithAxis(allAxis[6], allAxis[7], allAxis[4], allAxis[3], "z", direction.z, direction.z, null)
		else:
			if(hackyMesh):
				hackyMesh.translation.x -= direction.x
			for i in leftFace:
				var vertex = tool_.get_vertex(i)
				vertex.x -= direction.x
				tool_.set_vertex(i, vertex)
			communicateWithAxis(allAxis[4], allAxis[5], allAxis[6], allAxis[1], "x", direction.x, -direction.x, null)
	elif(lastAxis == "BottomLeft"):
		if(abs(direction.z) > abs(direction.x)):
			if(hackyMesh):
				hackyMesh.translation.z -= direction.z
			for i in backFace:
				var vertex = tool_.get_vertex(i)
				vertex.z -= direction.z
				tool_.set_vertex(i, vertex)
			communicateWithAxis(allAxis[7], allAxis[6], allAxis[4], allAxis[2], "z", direction.z, direction.z, null)
		else:
			if(hackyMesh):
				hackyMesh.translation.x -= direction.x
			for i in rightFace:
				var vertex = tool_.get_vertex(i)
				vertex.x -= direction.x
				tool_.set_vertex(i, vertex)
			communicateWithAxis(allAxis[4], allAxis[5], allAxis[7], allAxis[0], "x", direction.x, null, null)
	elif(lastAxis == "TopLeft"):
		if(abs(direction.z) > abs(direction.x)):
			if(hackyMesh):
				hackyMesh.translation.z -= direction.z
			for i in frontFace:
				var vertex = tool_.get_vertex(i)
				vertex.z -= direction.z
				tool_.set_vertex(i, vertex)
			#print(allAxis)
			communicateWithAxis(allAxis[7], allAxis[6], allAxis[5], allAxis[1], "z", direction.z, null, null)
		else:
			if(hackyMesh):
				hackyMesh.translation.x -= direction.x
			for i in rightFace:
				var vertex = tool_.get_vertex(i)
				vertex.x -= direction.x
				tool_.set_vertex(i, vertex)
			communicateWithAxis(allAxis[5], allAxis[4], allAxis[7], allAxis[3], "x", direction.x, null, null)
	elif(lastAxis == "TopRight"):
		if(abs(direction.z) > abs(direction.x)):
			if(hackyMesh):
				hackyMesh.translation.z -= direction.z
			for i in frontFace:
				var vertex = tool_.get_vertex(i)
				vertex.z -= direction.z
				tool_.set_vertex(i, vertex)
			communicateWithAxis(allAxis[7], allAxis[6], allAxis[5], allAxis[0], "z", -direction.z, null, direction.z)
		else:
			if(hackyMesh):
				hackyMesh.translation.x -= direction.x
			for i in leftFace:
				var vertex = tool_.get_vertex(i)
				vertex.x -= direction.x
				tool_.set_vertex(i, vertex)
			communicateWithAxis(allAxis[5], allAxis[4], allAxis[6], allAxis[2], "x", direction.x, -direction.x, null)
		
	mesh.surface_remove(0)
	tool_.commit_to_surface(mesh)
	#csgBox.scale += -1*direction
#	if(csgBox.scale.x < 0 and csgBox.scale.y < 0 and csgBox.scale.z < 0):
#		csgBox.invert_faces = true
#	elif( (csgBox.scale.x < 0 and csgBox.scale.y < 0) or (csgBox.scale.x < 0 and csgBox.scale.z < 0) or (csgBox.scale.y < 0 and csgBox.scale.z < 0)):
#		csgBox.invert_faces = false
#	elif (csgBox.scale.x < 0 or csgBox.scale.y < 0 or csgBox.scale.z < 0):
#		csgBox.invert_faces = true
#	else:
#		csgBox.invert_faces = false

func receiveName(name, lastMesh):
	lastAxis = name
	hackyMesh = lastMesh
	if(lastAxis != "NAN"):
		get_node(lastAxis).disableBar()

func chilling():
	if(lastAxis != "NAN"):
		get_node(lastAxis).disableBar()

func movingMe(direction):
	if(touchedCSG):
		self.translation.x = direction.x
		self.translation.y = max(direction.y, touchedCSG.translation.y+0.1)
		self.translation.z = direction.z
	else:
		self.translation = direction

func _on_CSGRigidBody_body_entered(body):
	var helper = body.get_parent()
	if(helper.name == "Floor"):
		touchedCSG = helper
#	if(helper.name == "Floor"):
#		self.translation.y = body.get_parent().translation.y+0.2


func _on_CSGRigidBody_body_exited(body):
	touchedCSG = null
	
#moving side axises makes it so the upper axises have to scale left or right with them
#moving the upper axises makes it so that the side axises have to scale up or down with them
func communicateWithAxis(firstAxis, secondAxis, moveOne, moveTwo, direction, amount, secondAmount, thirdAmount):
	#ExtureUpperLR
	if(direction == "z"):
		if(secondAmount):
			firstAxis.scale.y += secondAmount*0.5
			firstAxis.translation.z -= secondAmount*0.45
			secondAxis.scale.y += secondAmount*0.5
			secondAxis.translation.z -= secondAmount*0.45
			moveOne.translation.z -= secondAmount
			moveTwo.translation.z -= secondAmount
		elif(thirdAmount):
			firstAxis.scale.y -= thirdAmount*0.5
			firstAxis.translation.z -= thirdAmount*0.45
			secondAxis.scale.y -= thirdAmount*0.5
			secondAxis.translation.z -= thirdAmount*0.45
			moveOne.translation.z -= thirdAmount
			moveTwo.translation.z -= thirdAmount
		else:
			firstAxis.scale.y -= amount*0.5
			firstAxis.translation.z -= amount*0.45
			secondAxis.scale.y -= amount*0.5
			secondAxis.translation.z -= amount*0.45
			moveOne.translation.z -= amount
			moveTwo.translation.z -= amount
	elif(direction == "x"):
		if(secondAmount):
			firstAxis.scale.x -= secondAmount*0.5
			secondAxis.scale.x -= secondAmount*0.5
		else:
			firstAxis.scale.x -= amount*0.5
			secondAxis.scale.x -= amount*0.5
		firstAxis.translation.x -= amount*0.45
		secondAxis.translation.x -= amount*0.45
		moveOne.translation.x -= amount
		moveTwo.translation.x -= amount
	elif(direction == "y"):
		var index = 0
		for elem in allAxis:
			if(elem.name != lastAxis):
				if index < 4:
					elem.scale.y -= amount*0.5
					elem.translation.y -= amount*0.5
				else:
					elem.translation.y -= amount
			index += 1
	else:
		pass
	
