class_name SquareBaseNode extends Node3D
var map_x: int
var map_y: int
# Use TraversibleNode
var isTraversible = false

func is_traversible():
	return false;

func _on_hover():
	pass

func _on_unhover():
	pass

func _on_click():
	print("click base")

func _on_flat_input_event(_camera, event, _position, _normal, _shape_idx):
		if event is InputEventMouseButton:
			if (event.button_index == MOUSE_BUTTON_LEFT):
				if (event.is_released()):
					_on_click()
