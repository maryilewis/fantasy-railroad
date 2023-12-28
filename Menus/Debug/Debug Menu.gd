class_name DebugMenu extends Control

func update_location(x, y):
	$Location.text = ("x: " + str(x) + " y:" + str(y))
