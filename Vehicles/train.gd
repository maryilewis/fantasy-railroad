class_name Train extends Node3D

# TODO if at destination, stop at 50% progress
# TODO if starting from stop, start at 50% progress

var destination_position: Vector2
var location: Vector2
var train_path = []
var train_instance
var train_progress: PathFollow3D
var current_road: SquareBaseNode
var current_road_path_key
var current_train_index = 0
var direction = -1
var arrived = false

var my_camera: MaryWorldCamera

# Called when the node enters the scene tree for the first time.
func _ready():
	place_train(12,12)
	#set_destination(46,51)
	pass


func _create_test_train_path():
	for i in range(10):
		for j in range(10):
			var key = GameData.map_plan[i][j]
			if (key == 'r'):
				var road = GameData.map_nodes[i][j]
				train_path.append(road)


func set_destination(x, y):
	train_path = [GameData.map_nodes[x][y]]
	train_path = find_shortest_path(current_road, [x, y])
	arrived = false


func find_shortest_path(start_node, destination):
	var visited_nodes = []
	var queue = []
	# push the first path into the queue
	queue.append([start_node])
	while (queue.size() > 0):
		# get the first path from the queue
		var path = queue[0].duplicate()
		queue.remove_at(0)
		# get the last node from the path
		var node = path[-1]
		# path found
		if [node.map_x, node.map_y] == destination:
			return path
		# enumerate all adjacent nodes, construct a 
		# new path and push it into the queue
		var adjacent_roads = find_adjacent_roads(node.map_x, node.map_y, visited_nodes)
		for road in adjacent_roads:
			var new_path = path.duplicate()
			new_path.append(road)
			queue.append(new_path)
	print("no path found to target location")
	return []
	

func find_adjacent_roads(x, y, visited_nodes):
	var adjacent_roads = []
	for offset in [[-1, 0], [1, 0], [0, -1], [0, 1]]:
		var map_x = x + offset[0]
		var map_y = y + offset[1]
		if (map_y >= 0 \
		and map_x >= 0 \
		and map_x < GameData.map_nodes.size() \
		and map_y < GameData.map_nodes[map_x].size() \
		and GameData.map_nodes[map_x][map_y].is_traversible() \
		and not visited_nodes.has([map_x,map_y])):
			adjacent_roads.append(GameData.map_nodes[map_x][map_y])
			visited_nodes.append([map_x,map_y])
	return adjacent_roads

func place_train(x, y):
	current_road = GameData.map_nodes[x][y]
	# TODO use existing direction logic
	current_road_path_key = "ew"
	train_progress = current_road.add_path_child(current_road_path_key, self)
	train_progress.progress_ratio = .5

func move_train_along():
	var prev_x
	var prev_y
	var next_x
	var next_y
	var curr_x
	var curr_y
	var entry_point
	var exit_point
	if (current_road != null):
		prev_x = current_road.map_x
		prev_y = current_road.map_y
		current_road.remove_path_child(current_road_path_key)
	current_road = train_path[0]
	curr_x = current_road.map_x
	curr_y = current_road.map_y
	if (train_path.size() > 1):
		next_x = train_path[1].map_x
		next_y = train_path[1].map_y
	# figure out direction logic by comparing map_x and y of previous, current, and next road
	if (prev_x):
		if (prev_y < curr_y):
			entry_point = "n"
		elif (prev_y > curr_y):
			entry_point = "s"
		elif (prev_x < curr_x):
			entry_point = "w"
		elif (prev_x > curr_x):
			entry_point = "e"
	if (next_x):
		if (next_y < curr_y):
			exit_point = "n"
		elif (next_y > curr_y):
			exit_point = "s"
		elif (next_x < curr_x):
			exit_point = "w"
		elif (next_x > curr_x):
			exit_point = "e"
	if (entry_point and not exit_point):
		exit_point = _get_opposite(entry_point)
	elif (exit_point and not entry_point):
		entry_point = _get_opposite(exit_point)
	current_road_path_key = entry_point + exit_point
	train_progress = current_road.add_path_child(current_road_path_key, self)


func _get_opposite(dir):
	match dir:
		'w':
			return 'e'
		'e':
			return 'w'
		'n':
			return 's'
		's':
			return 'n'

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (train_path.size() == 0):
		if !arrived:
			arrived = true;

	elif (train_progress != null and train_progress.progress_ratio >= .99):
		train_path.remove_at(0)
		if (train_path.size() > 0):
			move_train_along()
