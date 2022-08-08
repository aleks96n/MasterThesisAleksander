extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var worldEnvi = get_node("WorldEnvironment")
onready var light = get_node("WorldEnvironment/DirectionalLight")
var speed = 1.5

onready var degrees = 1

var colorValues = {0:  Color8(255, 56, 0, 0), 1: Color8(255, 55, 0, 0), 2: Color8(255, 54, 0, 0), 3:  Color8(255, 71, 0, 0), 4: Color8(255, 70, 0, 0), 5: Color8(255, 69, 0, 0), 6:  Color8(255, 83, 0, 0), 7: Color8(255, 82, 0, 0), 8: Color8(255, 81, 0, 0), 9:  Color8(255, 93, 0, 0), 10: Color8(255, 92, 0, 0), 11: Color8(255, 91, 0, 0), 12:  Color8(255, 101, 0, 0), 13: Color8(255, 100, 0, 0), 14: Color8(255, 99, 0, 0), 15:  Color8(255, 109, 0, 0), 16: Color8(255, 108, 0, 0), 17: Color8(255, 107, 0, 0), 18:  Color8(255, 115, 0, 0), 19: Color8(255, 114, 0, 0), 20: Color8(255, 113, 0, 0), 21:  Color8(255, 121, 0, 0), 22: Color8(255, 120, 0, 0), 23: Color8(255, 119, 0, 0), 24:  Color8(255, 126, 0, 0), 25: Color8(255, 125, 0, 0), 26: Color8(255, 124, 0, 0), 27:  Color8(255, 131, 0, 0), 28: Color8(255, 130, 0, 0), 29: Color8(255, 129, 0, 0), 30:  Color8(255, 138, 18, 0), 31: Color8(255, 137, 18, 0), 32: Color8(255, 136, 18, 0), 33:  Color8(255, 142, 33, 0), 34: Color8(255, 141, 33, 0), 35: Color8(255, 140, 33, 0), 36:  Color8(255, 147, 44, 0), 37: Color8(255, 146, 44, 0), 38: Color8(255, 145, 44, 0), 39:  Color8(255, 152, 54, 0), 40: Color8(255, 151, 54, 0), 41: Color8(255, 150, 54, 0), 42:  Color8(255, 157, 63, 0), 43: Color8(255, 156, 63, 0), 44: Color8(255, 155, 63, 0), 45:  Color8(255, 161, 72, 0), 46: Color8(255, 160, 72, 0), 47: Color8(255, 159, 72, 0), 48:  Color8(255, 165, 79, 0), 49: Color8(255, 164, 79, 0), 50: Color8(255, 163, 79, 0), 51:  Color8(255, 169, 87, 0), 52: Color8(255, 168, 87, 0), 53: Color8(255, 167, 87, 0), 54:  Color8(255, 173, 94, 0), 55: Color8(255, 172, 94, 0), 56: Color8(255, 171, 94, 0), 57:  Color8(255, 177, 101, 0), 58: Color8(255, 176, 101, 0), 59: Color8(255, 175, 101, 0), 60:  Color8(255, 180, 107, 0), 61: Color8(255, 179, 107, 0), 62: Color8(255, 178, 107, 0), 63:  Color8(255, 184, 114, 0), 64: Color8(255, 183, 114, 0), 65: Color8(255, 182, 114, 0), 66:  Color8(255, 187, 120, 0), 67: Color8(255, 186, 120, 0), 68: Color8(255, 185, 120, 0), 69:  Color8(255, 190, 126, 0), 70: Color8(255, 189, 126, 0), 71: Color8(255, 188, 126, 0), 72:  Color8(255, 193, 132, 0), 73: Color8(255, 192, 132, 0), 74: Color8(255, 191, 132, 0), 75:  Color8(255, 196, 137, 0), 76: Color8(255, 195, 137, 0), 77: Color8(255, 194, 137, 0), 78:  Color8(255, 199, 143, 0), 79: Color8(255, 198, 143, 0), 80: Color8(255, 197, 143, 0), 81:  Color8(255, 201, 148, 0), 82: Color8(255, 200, 148, 0), 83: Color8(255, 199, 148, 0), 84:  Color8(255, 204, 153, 0), 85: Color8(255, 203, 153, 0), 86: Color8(255, 202, 153, 0), 87:  Color8(255, 206, 159, 0), 88: Color8(255, 205, 159, 0), 89: Color8(255, 204, 159, 0), 90:  Color8(255, 209, 163, 0),91:  Color8(255, 221, 190, 0), 92: Color8(255, 220, 190, 0), 93:  Color8(255, 223, 194, 0), 94: Color8(255, 222, 194, 0), 95:  Color8(255, 225, 198, 0), 96: Color8(255, 224, 198, 0), 97:  Color8(255, 227, 202, 0), 98: Color8(255, 226, 202, 0), 99:  Color8(255, 228, 206, 0), 100: Color8(255, 227, 206, 0), 101:  Color8(255, 230, 210, 0), 102: Color8(255, 229, 210, 0), 103:  Color8(255, 232, 213, 0), 104: Color8(255, 231, 213, 0), 105:  Color8(255, 233, 217, 0), 106: Color8(255, 232, 217, 0), 107:  Color8(255, 235, 220, 0), 108: Color8(255, 234, 220, 0), 109:  Color8(255, 236, 224, 0), 110: Color8(255, 235, 224, 0), 111:  Color8(255, 238, 227, 0), 112: Color8(255, 237, 227, 0), 113:  Color8(255, 239, 230, 0), 114: Color8(255, 238, 230, 0), 115:  Color8(255, 240, 233, 0), 116: Color8(255, 239, 233, 0), 117:  Color8(255, 242, 236, 0), 118: Color8(255, 241, 236, 0), 119:  Color8(255, 243, 239, 0), 120: Color8(255, 242, 239, 0), 121:  Color8(255, 244, 242, 0), 122: Color8(255, 243, 242, 0), 123:  Color8(255, 245, 245, 0), 124: Color8(255, 244, 245, 0), 125:  Color8(255, 246, 247, 0), 126: Color8(255, 245, 247, 0), 127:  Color8(255, 248, 251, 0), 128: Color8(255, 247, 251, 0), 129:  Color8(255, 249, 253, 0), 130: Color8(255, 248, 253, 0), 131:  Color8(254, 249, 255, 0), 132: Color8(254, 248, 255, 0), 133:  Color8(252, 247, 255, 0), 134: Color8(252, 246, 255, 0), 135:  Color8(249, 246, 255, 0), 136: Color8(249, 245, 255, 0), 137:  Color8(247, 245, 255, 0), 138: Color8(247, 244, 255, 0), 139:  Color8(245, 243, 255, 0), 140: Color8(245, 242, 255, 0), 141:  Color8(243, 242, 255, 0), 142: Color8(243, 241, 255, 0), 143:  Color8(240, 241, 255, 0), 144: Color8(240, 240, 255, 0), 145:  Color8(239, 240, 255, 0), 146: Color8(239, 239, 255, 0), 147:  Color8(237, 239, 255, 0), 148: Color8(237, 238, 255, 0), 149:  Color8(235, 238, 255, 0), 150: Color8(235, 237, 255, 0), 151:  Color8(233, 237, 255, 0), 152: Color8(233, 236, 255, 0), 153:  Color8(231, 236, 255, 0), 154: Color8(231, 235, 255, 0), 155:  Color8(230, 235, 255, 0), 156: Color8(230, 234, 255, 0), 157:  Color8(228, 234, 255, 0), 158: Color8(228, 233, 255, 0), 159:  Color8(227, 233, 255, 0), 160: Color8(227, 232, 255, 0), 161:  Color8(225, 232, 255, 0), 162: Color8(225, 231, 255, 0), 163:  Color8(224, 231, 255, 0), 164: Color8(224, 230, 255, 0), 165:  Color8(222, 230, 255, 0), 166: Color8(222, 229, 255, 0), 167:  Color8(221, 230, 255, 0), 168: Color8(221, 229, 255, 0), 169:  Color8(220, 229, 255, 0), 170: Color8(220, 228, 255, 0), 171:  Color8(218, 229, 255, 0), 172: Color8(218, 228, 255, 0), 173:  Color8(217, 227, 255, 0), 174: Color8(217, 226, 255, 0), 175:  Color8(216, 227, 255, 0), 176: Color8(216, 226, 255, 0), 177:  Color8(215, 226, 255, 0), 178: Color8(215, 225, 255, 0), 179:  Color8(214, 225, 255, 0), 180: Color8(214, 224, 25, 0)}



# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	degrees+=0.01
#	var helper = degrees*speed
#	worldEnvi.environment.background_sky.sun_latitude = helper
#	if(degrees >= 360):
#		degrees = 0
#	elif(degrees >= 270):
#		$Tween.interpolate_property(light, "light_color", light.light_color, Color8(255, 249, 253), 10, Tween.TRANS_LINEAR)
#		$Tween.interpolate_property(worldEnvi.environment.background_sky, "sun_color", worldEnvi.environment.background_sky.sun_color, Color8(255, 249, 253), 10, Tween.TRANS_LINEAR)	
#	elif(degrees >= 180):
#		$Tween.interpolate_property(light, "light_color", light.light_color, Color8(255, 157, 63), 10, Tween.TRANS_LINEAR)
#		$Tween.interpolate_property(worldEnvi.environment.background_sky, "sun_color", worldEnvi.environment.background_sky.sun_color, Color8(255, 157, 63), 10, Tween.TRANS_LINEAR)
#	elif(degrees >= 90):
#		$Tween.interpolate_property(light, "light_color", light.light_color, Color8(2, 7, 75), 10, Tween.TRANS_LINEAR)
#		$Tween.interpolate_property(worldEnvi.environment.background_sky, "sun_color", worldEnvi.environment.background_sky.sun_color, Color8(2, 7, 75), 10, Tween.TRANS_LINEAR)
#	elif(degrees >= 10):
#		$Tween.interpolate_property(light, "light_color", light.light_color, Color8(255, 249, 253), 10, Tween.TRANS_LINEAR)
#		$Tween.interpolate_property(worldEnvi.environment.background_sky, "sun_color", worldEnvi.environment.background_sky.sun_color,Color8(255, 249, 253), 10, Tween.TRANS_LINEAR)
#	else:
#		$Tween.interpolate_property(light, "light_color", light.light_color, Color8(255, 157, 63), 10, Tween.TRANS_LINEAR)
#		$Tween.interpolate_property(worldEnvi.environment.background_sky, "sun_color", worldEnvi.environment.background_sky.sun_color, Color8(255, 157, 63), 10, Tween.TRANS_LINEAR)
#	$Tween.start()
#
#
#	light.rotation_degrees.x = helper + 180
	pass
