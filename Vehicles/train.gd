class_name Train extends Node3D

var train_path = []
var train_instance
var train_progress: PathFollow3D
var current_road: RoadNode
var current_train_index = 0
var direction = -1

var my_camera: MaryWorldCamera

# Called when the node enters the scene tree for the first time.
func _ready():
	_create_test_train_path()
	move_train_along()

func _create_test_train_path():
	for i in range(10):
		for j in range(10):
			var key = GameData.map_plan[i][j]
			if (key == 'r'):
				var road = GameData.map_nodes[i][j]
				train_path.append(road)

func move_train_along():
	if (current_road != null):
		current_road.remove_path_child()
	current_road = train_path[current_train_index]
	if (direction == -1):
		train_progress = current_road.add_path_child_ew(self)
	elif (direction == 1):
		train_progress = current_road.add_path_child_we(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var path_length = train_path.size() - 1
	if (train_progress.progress_ratio >= .99):
		if (current_train_index == path_length and direction == 1):
			direction = -1
		elif (current_train_index == 0 and direction == -1):
			direction = 1
		else:
			current_train_index += direction
		move_train_along()


func _on_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		GameData.world_camera.set_follow_ref($Train)
