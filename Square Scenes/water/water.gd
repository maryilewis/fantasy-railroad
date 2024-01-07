class_name WaterNode extends SquareBaseNode

var flat_material = preload("res://Square Scenes/materials/transparent.tres")

func _init():
	_is_buildable = true
	_is_traversible = false
	road_cost = 12

