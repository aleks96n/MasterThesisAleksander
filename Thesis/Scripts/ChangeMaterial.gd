extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var controlBox = get_tree().get_root().get_node("Spatial/Control/WindowDialog")
export var brickMaterial : Material
export var glassMaterial : Material
export var woodMaterial : Material

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func _on_Area_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed == true:
			controlBox.popup()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Brick_pressed():
	self.material_override = brickMaterial


func _on_Wood_pressed():
	self.material_override = glassMaterial


func _on_Wood2_pressed():
	self.material_override = woodMaterial
