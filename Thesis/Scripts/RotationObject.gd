extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Pivot = get_node("Something/Pivot")
onready var sun = get_node("Something/Pivot/DirectionalLight")
onready var world = get_node("WorldEnvironment")
onready var white = Color(1,1,1,1)
onready var black = Color(0,0,0,0)

var colorValues = {0:  Color(255, 56, 0, 0), 1: Color(255, 55, 0, 0), 2: Color(255, 54, 0, 0), 3:  Color(255, 71, 0, 0), 4: Color(255, 70, 0, 0), 5: Color(255, 69, 0, 0), 6:  Color(255, 83, 0, 0), 7: Color(255, 82, 0, 0), 8: Color(255, 81, 0, 0), 9:  Color(255, 93, 0, 0), 10: Color(255, 92, 0, 0), 11: Color(255, 91, 0, 0), 12:  Color(255, 101, 0, 0), 13: Color(255, 100, 0, 0), 14: Color(255, 99, 0, 0), 15:  Color(255, 109, 0, 0), 16: Color(255, 108, 0, 0), 17: Color(255, 107, 0, 0), 18:  Color(255, 115, 0, 0), 19: Color(255, 114, 0, 0), 20: Color(255, 113, 0, 0), 21:  Color(255, 121, 0, 0), 22: Color(255, 120, 0, 0), 23: Color(255, 119, 0, 0), 24:  Color(255, 126, 0, 0), 25: Color(255, 125, 0, 0), 26: Color(255, 124, 0, 0), 27:  Color(255, 131, 0, 0), 28: Color(255, 130, 0, 0), 29: Color(255, 129, 0, 0), 30:  Color(255, 138, 18, 0), 31: Color(255, 137, 18, 0), 32: Color(255, 136, 18, 0), 33:  Color(255, 142, 33, 0), 34: Color(255, 141, 33, 0), 35: Color(255, 140, 33, 0), 36:  Color(255, 147, 44, 0), 37: Color(255, 146, 44, 0), 38: Color(255, 145, 44, 0), 39:  Color(255, 152, 54, 0), 40: Color(255, 151, 54, 0), 41: Color(255, 150, 54, 0), 42:  Color(255, 157, 63, 0), 43: Color(255, 156, 63, 0), 44: Color(255, 155, 63, 0), 45:  Color(255, 161, 72, 0), 46: Color(255, 160, 72, 0), 47: Color(255, 159, 72, 0), 48:  Color(255, 165, 79, 0), 49: Color(255, 164, 79, 0), 50: Color(255, 163, 79, 0), 51:  Color(255, 169, 87, 0), 52: Color(255, 168, 87, 0), 53: Color(255, 167, 87, 0), 54:  Color(255, 173, 94, 0), 55: Color(255, 172, 94, 0), 56: Color(255, 171, 94, 0), 57:  Color(255, 177, 101, 0), 58: Color(255, 176, 101, 0), 59: Color(255, 175, 101, 0), 60:  Color(255, 180, 107, 0), 61: Color(255, 179, 107, 0), 62: Color(255, 178, 107, 0), 63:  Color(255, 184, 114, 0), 64: Color(255, 183, 114, 0), 65: Color(255, 182, 114, 0), 66:  Color(255, 187, 120, 0), 67: Color(255, 186, 120, 0), 68: Color(255, 185, 120, 0), 69:  Color(255, 190, 126, 0), 70: Color(255, 189, 126, 0), 71: Color(255, 188, 126, 0), 72:  Color(255, 193, 132, 0), 73: Color(255, 192, 132, 0), 74: Color(255, 191, 132, 0), 75:  Color(255, 196, 137, 0), 76: Color(255, 195, 137, 0), 77: Color(255, 194, 137, 0), 78:  Color(255, 199, 143, 0), 79: Color(255, 198, 143, 0), 80: Color(255, 197, 143, 0), 81:  Color(255, 201, 148, 0), 82: Color(255, 200, 148, 0), 83: Color(255, 199, 148, 0), 84:  Color(255, 204, 153, 0), 85: Color(255, 203, 153, 0), 86: Color(255, 202, 153, 0), 87:  Color(255, 206, 159, 0), 88: Color(255, 205, 159, 0), 89: Color(255, 204, 159, 0), 90:  Color(255, 209, 163, 0),91:  Color(255, 221, 190, 0), 92: Color(255, 220, 190, 0), 93:  Color(255, 223, 194, 0), 94: Color(255, 222, 194, 0), 95:  Color(255, 225, 198, 0), 96: Color(255, 224, 198, 0), 97:  Color(255, 227, 202, 0), 98: Color(255, 226, 202, 0), 99:  Color(255, 228, 206, 0), 100: Color(255, 227, 206, 0), 101:  Color(255, 230, 210, 0), 102: Color(255, 229, 210, 0), 103:  Color(255, 232, 213, 0), 104: Color(255, 231, 213, 0), 105:  Color(255, 233, 217, 0), 106: Color(255, 232, 217, 0), 107:  Color(255, 235, 220, 0), 108: Color(255, 234, 220, 0), 109:  Color(255, 236, 224, 0), 110: Color(255, 235, 224, 0), 111:  Color(255, 238, 227, 0), 112: Color(255, 237, 227, 0), 113:  Color(255, 239, 230, 0), 114: Color(255, 238, 230, 0), 115:  Color(255, 240, 233, 0), 116: Color(255, 239, 233, 0), 117:  Color(255, 242, 236, 0), 118: Color(255, 241, 236, 0), 119:  Color(255, 243, 239, 0), 120: Color(255, 242, 239, 0), 121:  Color(255, 244, 242, 0), 122: Color(255, 243, 242, 0), 123:  Color(255, 245, 245, 0), 124: Color(255, 244, 245, 0), 125:  Color(255, 246, 247, 0), 126: Color(255, 245, 247, 0), 127:  Color(255, 248, 251, 0), 128: Color(255, 247, 251, 0), 129:  Color(255, 249, 253, 0), 130: Color(255, 248, 253, 0), 131:  Color(254, 249, 255, 0), 132: Color(254, 248, 255, 0), 133:  Color(252, 247, 255, 0), 134: Color(252, 246, 255, 0), 135:  Color(249, 246, 255, 0), 136: Color(249, 245, 255, 0), 137:  Color(247, 245, 255, 0), 138: Color(247, 244, 255, 0), 139:  Color(245, 243, 255, 0), 140: Color(245, 242, 255, 0), 141:  Color(243, 242, 255, 0), 142: Color(243, 241, 255, 0), 143:  Color(240, 241, 255, 0), 144: Color(240, 240, 255, 0), 145:  Color(239, 240, 255, 0), 146: Color(239, 239, 255, 0), 147:  Color(237, 239, 255, 0), 148: Color(237, 238, 255, 0), 149:  Color(235, 238, 255, 0), 150: Color(235, 237, 255, 0), 151:  Color(233, 237, 255, 0), 152: Color(233, 236, 255, 0), 153:  Color(231, 236, 255, 0), 154: Color(231, 235, 255, 0), 155:  Color(230, 235, 255, 0), 156: Color(230, 234, 255, 0), 157:  Color(228, 234, 255, 0), 158: Color(228, 233, 255, 0), 159:  Color(227, 233, 255, 0), 160: Color(227, 232, 255, 0), 161:  Color(225, 232, 255, 0), 162: Color(225, 231, 255, 0), 163:  Color(224, 231, 255, 0), 164: Color(224, 230, 255, 0), 165:  Color(222, 230, 255, 0), 166: Color(222, 229, 255, 0), 167:  Color(221, 230, 255, 0), 168: Color(221, 229, 255, 0), 169:  Color(220, 229, 255, 0), 170: Color(220, 228, 255, 0), 171:  Color(218, 229, 255, 0), 172: Color(218, 228, 255, 0), 173:  Color(217, 227, 255, 0), 174: Color(217, 226, 255, 0), 175:  Color(216, 227, 255, 0), 176: Color(216, 226, 255, 0), 177:  Color(215, 226, 255, 0), 178: Color(215, 225, 255, 0), 179:  Color(214, 225, 255, 0), 180: Color(214, 224, 25, 0)}
var skyValues = ["ffd94e", "e0c360", "c1ad73", ""]

export var rotation_speed = PI

func _process(delta):
	Pivot.rotate_x(rotation_speed*delta*0.1)
	var helper = int(Pivot.rotation_degrees.x)
	print(helper)
	#if(helper > 0):
		#world.environment.ambient_light_color = colorValues[helper]
		#
	#	#daylight
	#else:
	#	world.environment.ambient_light_color = colorValues[abs(helper)]
		#nightlight
	#if(Pivot.global_transform.origin.y < sun.global_transform.origin.y):
	#	sun.light_color = white
	#else:
	#	sun.light_color = black
	

# Called when the node enters the scene tree for the first time.
func _ready():
	#world.environment.ambient_light_color = Color(246,7,7,255)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
