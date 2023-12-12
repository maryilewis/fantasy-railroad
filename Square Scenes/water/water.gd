class_name WaterNode extends Buildable

var flat_material = preload("res://Square Scenes/materials/transparent.tres")

func _on_unhover():
	flat_mesh.set_surface_override_material(0, flat_material)
