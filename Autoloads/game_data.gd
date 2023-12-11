extends Node

#region camera
var world_camera: MaryWorldCamera
var train_camera: TrainCamera
#endregion

#region cursor states
enum CursorState {FREE, SELECTING_TRAIN_DESTINATION}
var cursor_state: CursorState = CursorState.FREE

# escape and maybe right click should trigger this
func free_cursor():
	cursor_state = CursorState.FREE
#endregion

#region direct trains
var target_train: Train

func set_selecting_train_destination():
	cursor_state = CursorState.SELECTING_TRAIN_DESTINATION

func set_target_train(node):
	target_train = node

func set_train_destination(node):
	if (cursor_state == CursorState.SELECTING_TRAIN_DESTINATION):
		cursor_state = CursorState.FREE
		target_train.set_destination(node.map_x, node.map_y)

#endregion

#region map
signal map_updated

@onready var flat = preload("res://Square Scenes/flat/flat.tscn")
@onready var forest = preload("res://Square Scenes/forest/forest.tscn")
@onready var water = preload("res://Square Scenes/water.tscn")
@onready var town = preload("res://Square Scenes/town/town.tscn")
@onready var road = preload("res://Square Scenes/road/road.tscn")
#@onready var road = preload("res://Square Scenes/road.tscn")
var map_plan = []
var map_nodes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	init_map_data()
	create_map()

func init_map_data():
	map_plan.append(['.', '.', '.', '.', 'w', '.', '.', '.', '.', '.'])
	map_plan.append(['.', '.', '.', '.', 'w', 'w', '.', '.', '.', '.'])
	map_plan.append(['.', '.', 'r', 'r', 'r', 'w', 'w', '.', '.', '.'])
	map_plan.append(['.', '.', 'r', 'f', 'r', 'r', 'r', 'r', 'r', '.'])
	map_plan.append(['.', '.', 'r', 'f', 'f', 'f', 'w', '.', 'r', '.'])
	map_plan.append(['.', '.', '.', '.', 'f', '.', 'w', '.', 'r', '.'])
	map_plan.append(['.', 't', 'r', 'r', 'r', 'r', 'r', 'r', 't', '.'])
	map_plan.append(['.', '.', '.', '.', '.', 'f', 'w', '.', '.', '.'])
	map_plan.append(['w', 'w', '.', '.', '.', '.', 'w', 'w', 'f', '.'])
	map_plan.append(['w', 'w', '.', '.', '.', '.', '.', 'w', '.', '.'])

func create_map():
	for i in range(10):
		GameData.map_nodes.append([])
		for j in range(10):
			var key = GameData.map_plan[i][j]
			var new_square
			match key:
				'.':
					new_square = flat.instantiate()
				'w':
					new_square = water.instantiate()
				'f':
					new_square = forest.instantiate()
				't':
					new_square = town.instantiate()
				'r':
					new_square = road.instantiate()
			new_square.position = Vector3(i, 0, j)
			new_square.map_x = i
			new_square.map_y = j
			if (new_square.is_traversible()):
				connect("map_updated", new_square.evaluate_visible_roads)
			add_child(new_square)
			GameData.map_nodes[i].append(new_square)
	# send signal that map is initialized
	emit_signal("map_updated")

#endregion

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
