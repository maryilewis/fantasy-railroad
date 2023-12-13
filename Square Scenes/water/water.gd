class_name WaterNode extends SquareBaseNode

var flat_material = preload("res://Square Scenes/materials/transparent.tres")

func _init():
	_is_buildable = true
	_is_traversible = false


func _on_unhover():
	flat_mesh.set_surface_override_material(0, flat_material)
