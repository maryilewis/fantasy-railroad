extends Node3D

enum CargoType {RED, BLUE}
var cargo_type: CargoType

var cargo_defs

# Called when the node enters the scene tree for the first time.
func _ready():
	cargo_defs = {
		CargoType.RED: {
			"display_name": "Red",
			"parent_ref": $Red,
			"mesh_instance": $Red/MeshInstance3D
		},
		CargoType.BLUE: {
			"display_name": "Blue",
			"parent_ref": $Blue,
			"mesh_instance": $Blue/MeshInstance3D
		}
	}

func set_cargo_type(type):
	cargo_type = type
	for def in cargo_defs:
		def.mesh_instance.visible = false
	if type != null:
		cargo_defs[type].mesh_instance.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
