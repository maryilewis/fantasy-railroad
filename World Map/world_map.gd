extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	GameData.world_camera = $Camera3D
	daynight_demo()

func _process(_delta):
	pass

#region color nonsense
func daynight_demo():
	make_day()

func make_night():
	print("make night")
	var night_tween = get_tree().create_tween() # or self.create_tween()?
	night_tween.tween_property($DirectionalLight3D, "light_color", Color.MIDNIGHT_BLUE, 10)
	night_tween.tween_callback(make_day).set_delay(1)

func make_day():
	print("make day")
	var day_tween = get_tree().create_tween()
	day_tween.tween_property($DirectionalLight3D, "light_color", Color.WHITE, 10)
	day_tween.tween_callback(make_night).set_delay(30)
#endregion
