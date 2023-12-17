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
	for train in trains:
		train.enable_click()
	
func set_selecting_train_destination():
	cursor_state = CursorState.SELECTING_TRAIN_DESTINATION
	for train in trains:
		train.enable_click()
	
func set_building():
	cursor_state = CursorState.BUILDING
	for train in trains:
		train.disable_click()
#endregion

#region direct trains
@onready var train_ref = preload("res://Vehicles/train.tscn")
var target_train: Train
var trains = []

func init_trains():
	var first_train = train_ref.instantiate()
	trains.append(first_train)
	for train in trains:
		add_child(train)
		print("train", train)
		target_train = train.get_engine()
		print("engine", train)

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
var map_plan = []
var map_nodes = []
var map_size = 100
var towns = []

# Called when the node enters the scene tree for the first time.
func _ready():
	print("planning map...")
	rng.seed = 12
	init_map_data2(map_size)
	print("creating map...")
	create_map()
	print("placing trains...")
	init_trains()

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
	map_plan[size/2][size/2] = 't'

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
					towns.append(new_square)
			new_square.position = Vector3(i - size/2, 0, j - size/2)
			new_square.map_x = i
			new_square.map_y = j
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
	map_nodes[x][y].build_road()
	for friend in get_traversible_neighbors(x, y):
		friend.evaluate_visible_roads()
	map_nodes[x][y].evaluate_visible_roads()
#endregion

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
