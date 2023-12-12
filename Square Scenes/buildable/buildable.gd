class_name Buildable extends SquareBaseNode

var flat_mesh: MeshInstance3D
var hover_material = preload("res://Square Scenes/materials/light.tres")

func _ready():
	flat_mesh = get_flat_mesh()

func _on_click():
	if (GameData.cursor_state == GameData.CursorState.BUILDING):
		GameData.build_road(map_x, map_y)

func _on_hover():
	if (GameData.cursor_state == GameData.CursorState.BUILDING):
		flat_mesh.set_surface_override_material(0, hover_material)

func _on_unhover():
	flat_mesh.set_surface_override_material(0, null)
