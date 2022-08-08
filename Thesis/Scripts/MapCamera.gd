extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#https://www.gdquest.com/tutorial/godot/2d/camera-zoom/
export var min_zoom = 500
export var max_zoom = 8000
export var zoom_factor = 50
export var zoom_duration = 0.2
onready var UI = get_node("HousePlacer")
onready var placing = false
onready var ray_length = 10000
onready var placableHouse = get_tree().get_root().get_node("Spatial/PlaceLater")
onready var roomCamera = get_tree().get_root().get_node("Spatial/PlaceLater/RoomCamera")
onready var greenBorder = get_tree().get_root().get_node("Spatial/PlaceLater/GreenBorder")
onready var giprobe = get_tree().get_root().get_node("Spatial/GIProbe")
#hard coded, check the plane y later
onready var y = 137

var _zoom_level = 5000 setget _set_zoom_level

onready var tween: Tween = $Tween

func _set_zoom_level(value):
	_zoom_level = clamp(value, min_zoom, max_zoom)
	tween.interpolate_property(
		self,
		"translation",
		translation,
		Vector3(self.translation.x, _zoom_level, self.translation.z),
		zoom_duration,
		tween.TRANS_SINE,
		tween.EASE_OUT
	)
	tween.start()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	UI.popup()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if placing:
		var mouse = get_viewport().get_mouse_position()
		var from = self.project_ray_origin(mouse)
		var to = from + self.project_ray_normal(mouse) * ray_length
		var helperVector = Vector3(to[0], y, to[2])
		placableHouse.set_translation(helperVector)
	

func _unhandled_input(event):
	if event.is_action_pressed("ui_wheel_down"):
		_set_zoom_level(_zoom_level - zoom_factor)
	elif event.is_action_pressed("ui_wheel_up"):
		_set_zoom_level(_zoom_level + zoom_factor)
	elif event.is_action_pressed("enter"):
		placing = false
		greenBorder.visible = false
		self.current = false
		roomCamera.current = true
		giprobe.set_translation(placableHouse.translation)
		giprobe.visible = true
		giprobe.bake()
	elif event.is_action_pressed("debugKey"):
		giprobe.bake()
		print(giprobe.translation)


func _on_Button_button_up():
	placing = true
