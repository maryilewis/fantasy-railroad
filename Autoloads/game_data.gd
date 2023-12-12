extends Node

#region camera
var world_camera: MaryWorldCamera
var train_camera: TrainCamera
#endregion

#region rng
var rng = RandomNumberGenerator.new()
#endregion

#region cursor states
enum CursorState {FREE, SELECTING_TRAIN_DESTINATION, BUILDING}
var cursor_state: CursorState = CursorState.FREE

# escape and maybe right click should trigger this
func free_cursor():
	cursor_state = CursorState.FREE
	
func set_selecting_train_destination():
	cursor_state = CursorState.SELECTING_TRAIN_DESTINATION
	
func set_building():
	cursor_state = CursorState.BUILDING
#endregion

#region direct trains
var target_train: Train

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
@onready var water = preload("res://Square Scenes/water/water.tscn")
@onready var town = preload("res://Square Scenes/town/town.tscn")
@onready var road = preload("res://Square Scenes/road/road.tscn")
#@onready var road = preload("res://Square Scenes/road.tscn")
var map_plan = []
var map_nodes = []
var world_parent

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.seed = 12
	#init_map_data()
	init_map_data2(100)
	create_map()

func init_map_data2(size):
	for i in size:
		map_plan.append([])
	for i in size:
		for j in size:
			var dice_roll = rng.randi_range(1, 100)
			var node_above
			var node_left
			if (j > 0):
				node_left = map_plan[i][j-1]
			if (i > 0):
				node_above = map_plan[i-1][j]
			if ((node_left == 'w' or node_above == 'w') and dice_roll >= 50):
				map_plan[i].append('w')
			elif ((node_left == 'f' or node_above == 'f') and dice_roll >= 70):
				map_plan[i].append('f')
			elif (dice_roll >= 90):
				map_plan[i].append('w')
			elif (dice_roll >= 80):
				map_plan[i].append('f')
			elif (dice_roll >= 75):
				map_plan[i].append('t')
			else:
				map_plan[i].append('.')
	map_plan[50][50] = 't'

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
	var size = GameData.map_plan.size()
	for i in range(size):
		GameData.map_nodes.append([])
		for j in range(size): #assumes a square
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
			new_square.position = Vector3(i - size/2, 0, j - size/2)
			new_square.map_x = i
			new_square.map_y = j
			if (new_square.is_traversible()):
				connect("map_updated", new_square.evaluate_visible_roads)
			GameData.map_nodes[i].append(new_square)
			add_child(new_square)
	# send signal that map is initialized
	emit_signal("map_updated")

#endregion

func get_traversible_neighbors(x, y):
	var neighbors = []
	for offset in [[-1, 0], [1, 0], [0, -1], [0, 1]]:
		var map_x = x + offset[0]
		var map_y = y + offset[1]
		if (map_y >= 0 \
			and map_x >= 0 \
			and map_x < GameData.map_nodes.size() \
			and map_y < GameData.map_nodes[map_x].size() \
			and GameData.map_nodes[map_x][map_y].is_traversible()):
				neighbors.append(GameData.map_nodes[map_x][map_y])
	return neighbors

#region building
func build_road(x, y):
	var node: Node3D = map_nodes[x][y]
	map_nodes[x][y] = road.instantiate()
	map_nodes[x][y].position = Vector3(x - 100/2, 0, y - 100/2) #TODO map size const
	map_nodes[x][y].map_x = x
	map_nodes[x][y].map_y = y
	
	add_child(map_nodes[x][y])
	remove_child(node)
	node.queue_free()
	for friend in get_traversible_neighbors(x, y):
		friend.evaluate_visible_roads()
	map_nodes[x][y].evaluate_visible_roads()
#endregion

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
