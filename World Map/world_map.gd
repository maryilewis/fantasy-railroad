extends Node3D

func _init():
	GameData.world_parent = self

# Called when the node enters the scene tree for the first time.
func _ready():
	GameData.world_camera = $Camera3D
	GameData.world_parent = self

#func _on_train_input_event(_camera, event, _position, _normal, _shape_idx):
#	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
#		my_camera.set_follow_ref(train_instance)
