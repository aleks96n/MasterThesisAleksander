extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var rayPosition = get_node("RayCast")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#maintainRotation()
	pass
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_left"):
		rayPosition.translation.x -= 0.5
	elif event.is_action_pressed("ui_right"):
		rayPosition.translation.x += 0.5
	elif event.is_action_pressed("ui_down"):
		rayPosition.translation.z += 0.5
	elif event.is_action_pressed("ui_up"):
		rayPosition.translation.z -= 0.5
	elif event.is_action_pressed("ui_wheel_up"):
		rayPosition.translation.y += 0.5
	elif event.is_action_pressed("ui_wheel_down"):
		rayPosition.translation.y -= 0.5
