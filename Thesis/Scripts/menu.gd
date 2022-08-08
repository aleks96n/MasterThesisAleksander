extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var pressedMaterial : Material
onready var add = get_node("Add/StaticBody")
onready var remove = get_node("Remove/StaticBody")
onready var material = get_node("Material/StaticBody")
onready var canvasSettings = get_parent().get_node("OQ_UI2DCanvas")
onready var parentGod = get_parent().get_parent().get_parent()
onready var doneCustom = get_node("ScrollMenu/DoneCustom")
onready var options = get_node("ScrollMenu/Options")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func logicButtons(type):
	if(type == "Add"):
		add.changeToNew(pressedMaterial)
		remove.changeToOrigin()
		material.changeToOrigin()
		parentGod.startPlacing()
		options.visible = false
		doneCustom.visible = true
	elif(type == "Remove"):
		add.changeToOrigin()
		remove.changeToNew(pressedMaterial)
		material.changeToOrigin()
		parentGod.startDeleting()
		options.visible = false
		doneCustom.visible = true
	else:
		add.changeToOrigin()
		remove.changeToOrigin()
		material.changeToNew(pressedMaterial)
		options.visible = true
		doneCustom.visible = false
