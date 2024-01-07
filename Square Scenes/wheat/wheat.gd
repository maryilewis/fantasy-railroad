class_name WheatNode extends SquareBaseNode

@onready var wheat_material = preload("res://Square Scenes/materials/wheat.tres")

func _init():
	_is_buildable = true
	_is_traversible = false
func _ready():
	flat_mesh.set_surface_override_material(0, wheat_material)
