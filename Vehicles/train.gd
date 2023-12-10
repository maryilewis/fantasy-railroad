class_name Train extends Node3D

var destination_position: Vector2
var location: Vector2
var train_path = []
var train_instance
var train_progress: PathFollow3D
var current_road: TraversibleNode
var current_train_index = 0
var direction = -1

var my_camera: MaryWorldCamera

# Called when the node enters the scene tree for the first time.
func _ready():
	place_train(6,7)
	set_destination(6,2)

func _create_test_train_path():
	for i in range(10):
		for j in range(10):
			var key = GameData.map_plan[i][j]
			if (key == 'r'):
				var road = GameData.map_nodes[i][j]
				train_path.append(road)
	for x in train_path:
		print("x: ", x.map_x, ", y: ", x.map_y)

func set_destination(x, y):
	print("set destination")
	train_path = [GameData.map_nodes[x][y]]
	train_path = find_shortest_path(current_road, [x, y])
	# get all roads in map_nodes
	# creade a lookup of the distance value for all roads
	# step = 1
	# starting with destination, find all adjacent roads if they don't have a distance value
	# # assign them a value of step
	# # add them to a list of nodes to check next
	
	#train_path.push_front()

func find_shortest_path(start_node, destination):
	var visited_nodes = []
	var queue = []
	# push the first path into the queue
	queue.append([start_node])
	while (queue.size() > 0):
		print("loop!")
		# get the first path from the queue
		var path = queue[0].duplicate()
		queue.remove_at(0)
		# get the last node from the path
		var node = path[-1]
		# path found
		if [node.map_x, node.map_y] == destination:
			print("it is found!")
			return path
		# enumerate all adjacent nodes, construct a 
		# new path and push it into the queue
		var adjacent_roads = find_adjacent_roads(node.map_x, node.map_y, visited_nodes)
		for road in adjacent_roads:
			print("adding new path to queue")
			var new_path = path.duplicate()
			new_path.append(road)
			queue.append(new_path)
		print("queue", queue)
	return []
	


func find_adjacent_roads(x, y, visited_nodes):
	print("find adjacent nodes")
	var adjacent_roads = []
	for offset in [[-1, 0], [1, 0], [0, -1], [0, 1]]:
		var map_x = x + offset[0]
		var map_y = y + offset[1]
		print(map_x, ", ", map_y)
		print(GameData.map_nodes[map_x][map_y].get_class())
		if (GameData.map_nodes[map_x][map_y].isTraversible and not visited_nodes.has([map_x,map_y])):
			print("trying...")
			adjacent_roads.append(GameData.map_nodes[map_x][map_y])
			visited_nodes.append([map_x,map_y])
	print("adjacent nodes", adjacent_roads)
	return adjacent_roads

func place_train(x, y):
	current_road = GameData.map_nodes[x][y]
	train_progress = current_road.add_path_child_ew(self)
	train_progress.progress_ratio = .5

func move_train_along():
	if (current_road != null):
		current_road.remove_path_child()
	current_road = train_path[0]
	# TODO figure out direction logic by comparing map_x and y of previous, current, and next road
	train_progress = current_road.add_path_child_ew(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (train_path.size() == 0):
		pass
	elif (train_progress != null and train_progress.progress_ratio >= .99):
		train_path.remove_at(0)
		if (train_path.size() > 0):
			move_train_along()


func _on_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		GameData.world_camera.set_follow_ref($Train)
