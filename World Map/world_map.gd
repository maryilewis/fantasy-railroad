extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	GameData.world_camera = $Camera3D


func _process(_delta):
	#daynight_demo()
	pass


var color_percent = 0
var up = true
const daylight_speed = .001	
func daynight_demo():
	if up:
		color_percent += daylight_speed
	else:
		color_percent -= daylight_speed
	if color_percent > 1:
		up = false;
		color_percent = 1
	elif color_percent < 0:
		up = true
		color_percent = 0
	$DirectionalLight3D.light_color = color_lerp(Color.WHITE, Color.DARK_BLUE, color_percent)


# TODO Move to util
func color_lerp(color1: Color, color2: Color, percent: float):
	var r = color1.r * (1 - percent) + color2.r * percent
	var g = color1.g * (1 - percent) + color2.g * percent
	var b = color1.b * (1 - percent) + color2.b * percent
	var a = color1.a * (1 - percent) + color2.a * percent
	return Color(r, g, b, a)
